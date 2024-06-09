
-- +migrate Up
alter table orders_results.orders
add column order_batch_id uuid;

-- +migrate Down
alter table orders_results.orders
drop column order_batch_id uuid;
