
-- +migrate Up
alter table orders_results.customer_facilities add column is_inlog_enabled boolean default false;
-- +migrate Down
alter table orders_results.customer_facilities drop column if exists is_inlog_enabled;
