
-- +migrate Up
CREATE TABLE orders_results.extra_values_ordered_examination_analytes (
    id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    examination_analyte_id UUID NOT NULL REFERENCES orders_results.ordered_examination_analytes (id),
    key varchar,
    value varchar,
    deleted_at timestamp null,
    modified_at timestamp null,
    created_at timestamp NOT null default (now() at time zone 'utc')
);
-- +migrate Down

DROP TABLE orders_results.extra_values_ordered_examination_analytes CASCADE;
