
-- +migrate Up
CREATE TABLE orders_results.extra_values (
     id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
     result_id UUID NOT NULL REFERENCES orders_results.results (id),
     key varchar,
     value varchar,
     value_type varchar,
     unit varchar,
     deleted_at timestamp null,
     modified_at timestamp null,
     created_at timestamp NOT null default (now() at time zone 'utc')
);
-- +migrate Down

DROP TABLE if exists orders_results.extra_values CASCADE;
