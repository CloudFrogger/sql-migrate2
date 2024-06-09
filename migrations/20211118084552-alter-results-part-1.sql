-- +migrate Up
ALTER TABLE orders_results.results
    ADD COLUMN result_type varchar;

-- +migrate Down
ALTER TABLE orders_results.results DROP COLUMN if exists result_type;

alter table orders_results.results
    alter column result_type_id set not null;
