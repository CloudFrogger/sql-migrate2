
-- +migrate Up
UPDATE orders_results.orders SET is_printed = false WHERE is_printed is null;
-- +migrate Down
