-- +migrate Up
ALTER TABLE orders_results.orders
    ADD COLUMN transfer_eia_date timestamp default null;

-- +migrate Down
ALTER TABLE orders_results.orders DROP COLUMN IF EXISTS transfer_eia_date;