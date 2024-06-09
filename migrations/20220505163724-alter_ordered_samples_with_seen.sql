
-- +migrate Up
ALTER TABLE orders_results.ordered_samples ADD seen_at TIMESTAMP NULL;

-- +migrate Down
ALTER TABLE orders_results.ordered_samples DROP COLUMN seen_at;