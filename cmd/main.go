package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"sort"
	"sql-migrate/internal/migrators"
	"sql-migrate/internal/readfiles"
	"strings"
	"time"

	"github.com/cristalhq/acmd"
	"gopkg.in/yaml.v2"
)

type dbconfigYml struct {
	Config struct {
		Dialect    string `yaml:"dialect"`
		Datasource string `yaml:"datasource"`
		Dir        string `yaml:"dir"`
		Table      string `yaml:"table"`
	} `yaml:"config"`
}

var cmds []acmd.Command = []acmd.Command{
	{
		Name: "new",
		ExecFunc: func(ctx context.Context, args []string) error {
			if len(args) == 0 {
				return fmt.Errorf("A name for the migration is needed")
			}
			dbconfigYml := readDbconfigYML()
			migration_file_name := fmt.Sprintf("%s-%s.sql", time.Now().Format("20060102150405"), args[0])
			if file, err := os.Create(filepath.Join(dbconfigYml.Config.Dir, migration_file_name)); err != nil {
				return err
			} else {
				defer file.Close()
				if _, err := file.WriteString("\n-- +migrate Up\n\n-- +migrate Down\n"); err != nil {
					return err
				}
			}
			return nil
		},
	},
	{
		Name: "up",
		ExecFunc: func(ctx context.Context, args []string) error {
			dbconfigYml := readDbconfigYML()
			upMigrations, _, err := readfiles.ReadMigrations(dbconfigYml.Config.Dir)
			if err != nil {
				return err
			}
			migrator, err := migrators.NewMigrator(dbconfigYml.Config.Dialect,
				dbconfigYml.Config.Datasource,
				dbconfigYml.Config.Table)
			if err != nil {
				return err
			}
			if err := migrator.Up(upMigrations); err != nil {
				return err
			}
			return nil
		},
	},
	{
		Name: "down",
		ExecFunc: func(ctx context.Context, args []string) error {
			dbconfigYml := readDbconfigYML()
			_, downMigrations, err := readfiles.ReadMigrations(dbconfigYml.Config.Dir)
			if err != nil {
				return err
			}
			migrator, err := migrators.NewMigrator(dbconfigYml.Config.Dialect,
				dbconfigYml.Config.Datasource,
				dbconfigYml.Config.Table)
			if err != nil {
				return err
			}
			if err := migrator.Down(downMigrations); err != nil {
				return err
			}
			return nil
		},
	},
	{
		Name: "status",
		ExecFunc: func(ctx context.Context, args []string) error {
			dbconfigYml := readDbconfigYML()
			upMigrations, _, err := readfiles.ReadMigrations(dbconfigYml.Config.Dir)
			if err != nil {
				return err
			}
			files := make([]string, 0, 1024)
			for key := range upMigrations {
				files = append(files, key)
			}
			if migrator, err := migrators.NewMigrator(dbconfigYml.Config.Dialect,
				dbconfigYml.Config.Datasource,
				dbconfigYml.Config.Table); err != nil {
				return err
			} else {
				if status, err := migrator.Status(files); err != nil {
					return err
				} else {
					maxlen := 20
					for key := range status {
						if len(key) > maxlen {
							maxlen = len(key)
						}
					}
					printStatusTable(status)
				}
				return nil
			}
		},
	},
}

func printStatusTable(data map[string]time.Time) {

	// Precompute widths
	maxKeyWidth := len("MIGRATION")
	maxTimeWidth := len("APPLIED")
	for key, timestamp := range data {
		if len(key) > maxKeyWidth {
			maxKeyWidth = len(key)
		}
		if len(timestamp.Format(time.RFC3339)) > maxTimeWidth {
			maxTimeWidth = len(timestamp.Format(time.RFC3339))
		}
	}

	// Row printer
	createRow := func(row []string, colWidths []int, separator string) string {
		parts := make([]string, len(row))
		for i, col := range row {
			parts[i] = fmt.Sprintf("%-*s", colWidths[i], col)
		}
		return separator + " " + strings.Join(parts, " "+separator+" ") + " " + separator
	}

	// Border
	colWidths := []int{maxKeyWidth, maxTimeWidth}
	horizontalLine := "+"
	for _, width := range colWidths {
		horizontalLine += strings.Repeat("-", width+2) + "+"
	}

	// Print table
	fmt.Println(horizontalLine)
	fmt.Println(createRow([]string{"MIGRATION", "APPLIED"}, colWidths, "|"))
	fmt.Println(horizontalLine)

	// sort the keys
	keys := make([]string, 0, len(data))
	for key := range data {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	for _, key := range keys {
		timestamp := data[key]
		if timestamp.IsZero() {
			fmt.Println(createRow([]string{key, "no"}, colWidths, "|"))
		} else {
			fmt.Println(createRow([]string{key, timestamp.Format(time.RFC3339)}, colWidths, "|"))
		}
	}
	fmt.Println(horizontalLine)
}

func main() {

	r := acmd.RunnerOf(cmds, acmd.Config{
		AppName:        "sql-migrate",
		AppDescription: "The most simple migrator and compatible to my favouritye migrator rubenv/sql-migrate",
		Version:        "0.5",
		// Context - if nil `signal.Notify` will be used
		// Args - if nil `os.Args[1:]` will be used
		// Usage - if nil default print will be used
	})

	if err := r.Run(); err != nil {
		if err == acmd.ErrNoArgs {
			fmt.Printf("Usage: sql-migrate [--version] [--help] <command> [<args>]\n\n")
			fmt.Printf("Available commands are:\n")
			fmt.Printf("\tdown\tUndo a database migration\n")
			fmt.Printf("\tnew\tCreate a new migration\n")
			fmt.Printf("\tredo\tReapply the last migration\n")
			fmt.Printf("\tskip\tSets the database level to the most recent version available, without running the migrations\n")
			fmt.Printf("\tstatus\tShow migration status\n")
			fmt.Printf("\tup\tMigrates the database to the most recent version available\n")
			return
		}
		r.Exit(err)
	}

}

// Read the configuration from dbconfig.yml
func readDbconfigYML() dbconfigYml {
	var dbconfig_yml dbconfigYml
	yamlFile, err := os.ReadFile("dbconfig.yml")
	if err != nil {
		log.Printf("%v ", err)
	}
	err = yaml.Unmarshal(yamlFile, &dbconfig_yml)
	if err != nil {
		log.Fatalf("%v", err)
	}

	dbconfig_yml.Config.Dialect = strings.ToLower(dbconfig_yml.Config.Dialect)
	if dbconfig_yml.Config.Dialect == "" {
		log.Fatal("No dialect specified. ")
	}
	if dbconfig_yml.Config.Table == "" { // default
		log.Fatal("No migrations table specified")
	}
	dbconfig_yml.Config.Datasource = os.ExpandEnv(dbconfig_yml.Config.Datasource)

	return dbconfig_yml
}
