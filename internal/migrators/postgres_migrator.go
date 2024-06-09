package migrators

import (
	"context"
	"fmt"
	"log"
	"sort"
	"time"

	"github.com/jackc/pgx/v4"
)

type postgresMigrator struct {
	Db              *pgx.Conn
	Migration_table string
}

func (m *postgresMigrator) Up(statements map[string]*[]string) error {

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

	for _, key := range keys {
		if myMigrations[key].IsZero() {
			tx, err := m.Db.BeginTx(context.Background(), pgx.TxOptions{}) // todo: cancellable + timeout
			if err != nil {
				return err
			}
			if err = m.applyStatements(tx, statements[key]); err != nil {
				tx.Rollback(context.Background())
				return err
			}
			if err = m.updateMigrationAsDone(key); err != nil {
				tx.Rollback(context.Background())
				return err
			}
			if err = tx.Commit(context.Background()); err != nil {
				return err
			}
		}
	}

	return nil
}

func (m *postgresMigrator) Down(statements map[string]*[]string) error {

	keys := make([]string, 0, len(statements))
	for key := range statements {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	migrationStatus, err := m.Status(keys)
	if err != nil {
		return err
	}

	lastAppliedKey := ""
	for i := len(keys) - 1; i >= 0; i-- {
		if !migrationStatus[keys[i]].IsZero() {
			lastAppliedKey = keys[i]
			break
		}
	}
	if lastAppliedKey == "" {
		return fmt.Errorf("no migration can be undone")
	}

	tx, err := m.Db.BeginTx(context.Background(), pgx.TxOptions{}) // todo: cancellable + timeout
	if err != nil {
		return err
	}
	if err = m.applyStatements(tx, statements[lastAppliedKey]); err != nil {
		tx.Rollback(context.Background())
		return err
	}
	if err = m.updateMigrationAsUndone(lastAppliedKey); err != nil {
		tx.Rollback(context.Background())
		return err
	}
	if err = tx.Commit(context.Background()); err != nil {
		return err
	}

	return nil
}

func (m *postgresMigrator) Status(migfiles []string) (map[string]time.Time, error) {

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

func (m *postgresMigrator) applyStatements(tx pgx.Tx, statements *[]string) error {

	for _, statement := range *statements {
		// fmt.Println("executing:", statement)
		_, err := tx.Exec(context.Background(), statement)
		if err != nil {
			return err
		}
	}
	return nil
}

func (m *postgresMigrator) ensureMigrationTableExists() error {
	_, err := m.Db.Exec(context.Background(), fmt.Sprintf("create table if not exists %s (id text primary key not null, applied_at timestamptz);", m.Migration_table))
	return err
}

func (m *postgresMigrator) updateMigrationAsDone(id string) error {
	_, err := m.Db.Exec(context.Background(),
		fmt.Sprintf("insert into %s (id, applied_at) values ($1, now()) on conflict (id) do update set applied_at = now() ",
			m.Migration_table), id)
	return err
}
func (m *postgresMigrator) updateMigrationAsUndone(id string) error {
	_, err := m.Db.Exec(context.Background(),
		fmt.Sprintf("insert into %s (id, applied_at) values ($1, null) on conflict (id) do update set applied_at = null ",
			m.Migration_table), id)
	return err
}
