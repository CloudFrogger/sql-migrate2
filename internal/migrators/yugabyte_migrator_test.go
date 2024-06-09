package migrators

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestBundleTransactions(t *testing.T) {
	DDL_STMT := `CREATE TABLE orders_results.result_value_types (
		id UUID NOT NULL DEFAULT uuid_generate_v4(),
		type VARCHAR NOT NULL,
		description VARCHAR NOT NULL,
		CONSTRAINT "result_value_types_primary" PRIMARY KEY (id)
	);`
	DML_STMT := `INSERT INTO
	orders_results.result_value_types (type, description) VALUES
	('int', 'Integer -2^32 .. +2^32'),
	('float', 'Floating value'),
	('string', 'String value'),
	('pein', 'pos, neg, err, inv, mat, inh, nor'),
	('react', 'rea, not, err, inv, mat, inh, nor'),
	('invalid', 'val, inv, err, nor'),
	('enum', 'defined with the analyte');`
	testcase := []string{DDL_STMT, DML_STMT}
	bt := split_DDL_DML_Transactions(&testcase)
	assert.Equal(t, 2, len(bt))
}
