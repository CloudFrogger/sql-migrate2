-- +migrate Up
alter table orders_results.results
    alter column status_type set not null;

alter table orders_results.results drop column if exists status_type_id;
-- +migrate Down

alter table orders_results.results
    add column status_type_id uuid null references orders_results.result_status_types (id);