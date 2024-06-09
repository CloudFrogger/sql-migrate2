
-- +migrate Up
ALTER TABLE orders_results.orders DROP COLUMN sample_date_temp;

ALTER TABLE orders_results.orders RENAME COLUMN sample_date_date TO sample_date;
ALTER TABLE orders_results.orders RENAME COLUMN sample_date_time TO sample_time;

ALTER TABLE orders_results.orders ALTER COLUMN sample_date SET NOT NULL;

-- +migrate Down
ALTER TABLE orders_results.orders ADD COLUMN sample_date_temp timestamp NULL;
ALTER TABLE orders_results.orders RENAME COLUMN sample_date TO sample_date_date;
ALTER TABLE orders_results.orders RENAME COLUMN sample_time TO sample_date_time;