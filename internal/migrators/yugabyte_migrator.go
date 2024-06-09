package migrators

import (
	"context"
	"fmt"
	"log"
	"sort"
	"strings"
	"time"

	"github.com/jackc/pgx/v4"
)

type yugabyteMigrator struct {
	Db              *pgx.Conn
	Migration_table string
}

type TransactionBundle struct {
	statements []string
}

func (m *yugabyteMigrator) Up(statements map[string]*[]string) error {

	m.ensureMigrationTableExists()

	keys := make([]string, 0, len(statements))
	for key := range statements {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	myMigrations, err := m.Status(keys)
	if err != nil {
		return err
	}

	transactions := []pgx.Tx{}

	for _, key := range keys {
		if myMigrations[key].IsZero() {

			atmoicDDLDMLTranscactions := split_DDL_DML_Transactions(statements[key])

			for _, atomic := range atmoicDDLDMLTranscactions {
				tx, err := m.Db.BeginTx(context.Background(), pgx.TxOptions{
					IsoLevel: pgx.Serializable,
				})
				if err != nil {
					return err
				}
				transactions = append(transactions, tx)
				fmt.Printf("\n------- Start transactionbundle -----------\n")
				if err = m.applyStatements(tx, &atomic.statements); err != nil {
					// make all pending transactions undone
					for i := len(transactions) - 1; i >= 0; i-- {
						transactions[i].Rollback(context.Background())
					}
					return err
				}
			}

			// commit all transactions regardless of error
			err = nil
			for i := len(transactions) - 1; i >= 0; i-- {
				errinner := transactions[i].Commit(context.Background())
				if err != nil {
					if err != nil {
						err = fmt.Errorf("%v - %v", errinner)
					} else {
						err = errinner
					}
				}
			}
			if err != nil {
				return err
			}

			// if this fails we are screwed
			if err = m.updateMigrationAsDone(key); err != nil {
				return err
			}
		}
	}

	return nil
}

func split_DDL_DML_Transactions(commands *[]string) []TransactionBundle {

	migs := []TransactionBundle{}

	transactionType := 0
	lastTransactionType := 0
	buffer := []string{}

	for _, statement := range *commands {
		if isDDL(statement) {
			transactionType = 1
		} else {
			//if isDML(statement) {
			transactionType = 2
			//}
		}
		if lastTransactionType != transactionType {
			if len(buffer) > 0 {
				migs = append(migs, TransactionBundle{
					statements: buffer,
				})
			}
			buffer = []string{statement}
			lastTransactionType = transactionType
		} else {
			buffer = append(buffer, statement)
		}
	}

	if len(buffer) > 0 {
		migs = append(migs, TransactionBundle{
			statements: buffer,
		})
	}

	return migs
}

func (m *yugabyteMigrator) Down(commands map[string]*[]string) error {

	return nil
}

func (m *yugabyteMigrator) Status(migfiles []string) (map[string]time.Time, error) {

	status := make(map[string]time.Time)

	// make sure to null the result
	for _, migfile := range migfiles {
		status[migfile] = time.Time{}
	}

	rows, err := m.Db.Query(context.Background(), fmt.Sprintf("SELECT id, applied_at FROM %s", m.Migration_table))
	if err != nil {
		return status, nil
	}
	defer rows.Close()

	for rows.Next() {
		var id string
		var applied_at *time.Time
		err := rows.Scan(&id, &applied_at)
		if err != nil {
			return nil, err
		}
		if _, ok := status[id]; ok {
			if applied_at != nil {
				status[id] = *applied_at
			} else {
				status[id] = time.Time{}
			}
		} else {
			return nil, fmt.Errorf("inconsitent migration. No migration-file exists for '%s", id)
		}
	}

	if rows.Err() != nil {
		log.Fatalf("Query iteration failed: %v\n", rows.Err())
	}

	return status, nil
}

func (m *yugabyteMigrator) ensureMigrationTableExists() error {
	_, err := m.Db.Exec(context.Background(), fmt.Sprintf("create table if not exists %s (id text primary key not null, applied_at timestamptz);", m.Migration_table))
	return err
}

func (m *yugabyteMigrator) applyStatements(tx pgx.Tx, statements *[]string) error {

	for _, statement := range *statements {
		fmt.Println(" stmt", statement)
		_, err := tx.Exec(context.Background(), statement)
		if err != nil {
			return err
		}
	}
	return nil
}

func (m *yugabyteMigrator) updateMigrationAsDone(id string) error {
	_, err := m.Db.Exec(context.Background(),
		fmt.Sprintf("insert into %s (id, applied_at) values ($1, now()) on conflict (id) do update set applied_at = now() ",
			m.Migration_table), id)
	return err
}

func (m *yugabyteMigrator) updateMigrationAsUndone(id string) error {
	_, err := m.Db.Exec(context.Background(),
		fmt.Sprintf("insert into %s (id, applied_at) values ($1, null) on conflict (id) do update set applied_at = null ",
			m.Migration_table), id)
	return err
}

func isDDL(sql string) bool {
	ddlCommands := []string{"CREATE", "ALTER", "DROP", "TRUNCATE"}
	for _, cmd := range ddlCommands {
		if strings.HasPrefix(strings.ToUpper(strings.TrimSpace(sql)), cmd) {
			return true
		}
	}
	return false
}

func isDML(sql string) bool {
	dmlCommands := []string{"INSERT", "UPDATE", "DELETE", "SELECT"}
	for _, cmd := range dmlCommands {
		if strings.HasPrefix(strings.ToUpper(strings.TrimSpace(sql)), cmd) {
			return true
		}
	}
	return false
}
