package migrators

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v4"
)

type Migrator interface {
	Up(commands map[string]*[]string) error
	Down(commands map[string]*[]string) error
	Status(migrations []string) (map[string]time.Time, error)
}

func NewMigrator(dialect string, connectionString string, migration_table string) (Migrator, error) {
	switch strings.ToLower(dialect) {
	case "postgres":
		//vars := parseConnectionString(connectionString)
		//connStr := "postgresql://username:password@localhost:5432/mydatabase"
		//connStr := fmt.Sprintf("postgresql://%s:%s@%s:%s/%s", vars["user"], vars["password"], vars["host"], vars["port"], vars["dbname"])
		//fmt.Printf("connstr:%s\n", connStr)
		conn, err := pgx.Connect(context.Background(), connectionString)
		if err != nil {
			return nil, fmt.Errorf("unable to connect to postgres - %v", err)
		}
		return &postgresMigrator{
			Db:              conn,
			Migration_table: migration_table,
		}, nil
	case "yugabyte":
		conn, err := pgx.Connect(context.Background(), connectionString)
		if err != nil {
			return nil, fmt.Errorf("unable to connect to postgres - %v", err)
		}
		return &yugabyteMigrator{
			Db:              conn,
			Migration_table: migration_table,
		}, nil
	}
	return nil, fmt.Errorf("unsupported dialect : '%s'", dialect)
}

func parseConnectionString(connStr string) map[string]string {
	result := make(map[string]string)

	// Connection-String in Paare teilen
	pairs := strings.Fields(connStr)
	for _, pair := range pairs {
		// Paare in Schlüssel und Wert teilen
		kv := strings.SplitN(pair, "=", 2)
		if len(kv) == 2 {
			key := kv[0]
			value := kv[1]
			result[key] = value
		}
	}

	return result
}
