
-- +migrate Up
alter table orders_results.orders add column successor_order_id uuid null references orders_results.orders(id);

-- +migrate Down
alter table orders_results.orders drop column if exists successor_order_id;

