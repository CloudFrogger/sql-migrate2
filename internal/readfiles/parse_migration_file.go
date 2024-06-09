package readfiles

import (
	"bufio"
	"os"
	"path/filepath"
	"strings"
)

func ReadMigrations(directory string) (map[string]*[]string, map[string]*[]string, error) {
	upmigrations := make(map[string]*[]string)
	downmigrations := make(map[string]*[]string)

	err := filepath.Walk(directory, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() && filepath.Ext(path) == ".sql" {
			content, err := os.ReadFile(path)
			if err != nil {
				return err
			}
			upMigration, downMigration, err := parseMigrationFile(string(content))
			if err != nil {
				return err
			}
			_, migrationName := filepath.Split(path)
			upmigrations[migrationName] = upMigration
			downmigrations[migrationName] = downMigration
		}

		return nil
	})
	return upmigrations, downmigrations, err
}

// This function crates a list of statements
func parseMigrationFile(input string) (*[]string, *[]string, error) {
	var upstatements []string
	var downstatements []string
	scanner := bufio.NewScanner(strings.NewReader(input))

	up_or_down := 0
	buffer := ""
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		// Verarbeiten Sie die Zeile hier
		if strings.HasPrefix(line, "--") {
			// upstatements = append(upstatements, line)
			if strings.ToLower(strings.TrimSpace(line)) == "-- +migrate up" {
				up_or_down = +1
			}
			if strings.ToLower(strings.TrimSpace(line)) == "-- +migrate down" {
				up_or_down = -1
			}
		} else {
			buffer = buffer + " " + line
			if strings.HasSuffix(buffer, ";") {
				if up_or_down == +1 {
					upstatements = append(upstatements, strings.TrimSpace(buffer))
				}
				if up_or_down == -1 {
					downstatements = append(downstatements, strings.TrimSpace(buffer))
				}
				buffer = ""
			}
		}
	}

	if err := scanner.Err(); err != nil {
		return &[]string{}, &[]string{}, err
	}

	return &upstatements, &downstatements, nil
}
