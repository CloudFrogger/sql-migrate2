
-- +migrate Up
ALTER TABLE orders_results.orders DROP COLUMN subject_updated;

-- +migrate Down
ALTER TABLE orders_results.orders ADD subject_updated BOOLEAN NOT NULL DEFAULT FALSE;