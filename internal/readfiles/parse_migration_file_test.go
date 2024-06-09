package readfiles

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParseMigrationfile(t *testing.T) {
	filedata := `
-- +migrate Up

create table test(id int);
	
-- +migrate Down
drop table test;`

	up, down, err := parseMigrationFile(filedata)
	assert.Nil(t, err)
	assert.Equal(t, "create table test(id int);", (*up)[0])
	assert.Equal(t, "drop table test;", (*down)[0])
}
func TestParseMigrationfile_MultilineSQL(t *testing.T) {
	filedata := `
  -- +migrate Up
create table 
	continued_in_nextline(id int);`

	up, _, err := parseMigrationFile(filedata)
	assert.Nil(t, err)
	assert.Equal(t, "create table continued_in_nextline(id int);", (*up)[0])
}
