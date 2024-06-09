
-- +migrate Up
ALTER TABLE orders_results.results ADD yielded_at timestamp NULL;

-- +migrate Down
ALTER TABLE orders_results.results DROP COLUMN yielded_at;