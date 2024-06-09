
-- +migrate Up
ALTER TABLE orders_results.orders ALTER COLUMN is_printed SET DEFAULT false;
-- +migrate Down
