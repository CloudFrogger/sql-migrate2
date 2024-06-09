
-- +migrate Up
alter table orders_results.results
    alter column result_type set not null;

alter table orders_results.results drop column if exists result_type_id;
-- +migrate Down
alter table orders_results.results
    add column result_type_id uuid null references orders_results.result_value_types (id);