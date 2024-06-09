-- +migrate Up

-------------------- result value types
CREATE TABLE orders_results.result_value_types (
	id UUID NOT NULL DEFAULT uuid_generate_v4(),
	type VARCHAR NOT NULL,
	description VARCHAR NOT NULL,
	CONSTRAINT "result_value_types_primary" PRIMARY KEY (id)
);

INSERT INTO
	orders_results.result_value_types (type, description)
VALUES
	('int', 'Integer -2^32 .. +2^32'),
	('float', 'Floating value'),
	('string', 'String value'),
	('pein', 'pos, neg, err, inv, mat, inh, nor'),
	('react', 'rea, not, err, inv, mat, inh, nor'),
	('invalid', 'val, inv, err, nor'),
	('enum', 'defined with the analyte');

-------------------- result status types
CREATE TABLE orders_results.result_status_types (
	id UUID NOT NULL DEFAULT uuid_generate_v4(),
	name VARCHAR NOT NULL,
	CONSTRAINT "result_status_types_primary" PRIMARY KEY (id)
);

INSERT INTO
	orders_results.result_status_types (name)
VALUES
('INVALID'),('ENT'),('PRC'),('PRE'),('VAL'),('FIN');

CREATE TABLE orders_results.results (
	id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
	ordered_examination_analyte_id UUID NOT NULL REFERENCES orders_results.ordered_examination_analytes (id),
	workitem_id VARCHAR NOT NULL,
	parent_result_id uuid NULL REFERENCES orders_results.results (id),
	analyte_id uuid NOT NULL,

	status_type_id UUID NOT null REFERENCES orders_results.result_status_types (id),
	status_time timestamp NOT NULL default (now() at time zone 'utc'),

	result_value VARCHAR NOT NULL default '',
	result_value_unit VARCHAR NOT NULL default '',
	result_type_id UUID NOT null REFERENCES orders_results.result_value_types (id),

	updated_and_replaced_at timestamp null,

	deleted_at timestamp null,
	modified_at timestamp null,
	created_at timestamp NOT null default (now() at time zone 'utc')
);

-- +migrate Down
DROP TABLE if exists orders_results.results CASCADE;

DROP TABLE if exists orders_results.result_status_types CASCADE;

DROP TABLE if exists orders_results.result_value_types CASCADE;