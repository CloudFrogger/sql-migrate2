
-- +migrate Up
ALTER TABLE orders_results.orders ALTER COLUMN is_printed SET Not NUll;
-- +migrate Down
