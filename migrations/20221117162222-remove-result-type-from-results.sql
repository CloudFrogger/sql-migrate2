
-- +migrate Up
ALTER TABLE orders_results.results
DROP COLUMN result_type;


-- +migrate Down
ALTER TABLE orders_results.results
ADD COLUMN result_type varchar not null default('');