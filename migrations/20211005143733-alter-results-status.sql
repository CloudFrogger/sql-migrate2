-- +migrate Up
alter table orders_results.results
    add column status_type varchar null;


-- +migrate Down

alter table orders_results.results
    alter column status_type_id set not null;

alter table orders_results.results drop column if exists status_type;