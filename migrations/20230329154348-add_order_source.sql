
-- +migrate Up
alter table orders_results.orders add column source text null;

-- +migrate Down
alter table orders_results.orders drop column if exists source;
