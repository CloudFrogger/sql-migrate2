
-- +migrate Up
ALTER TABLE orders_results.customer_facilities
DROP COLUMN is_inlog_enabled;

-- +migrate Down
ALTER TABLE orders_results.customer_facilities
ADD COLUMN is_inlog_enabled bool default(true);