-- +migrate Up
ALTER TABLE orders_results.orders ADD COLUMN sample_date_date DATE NULL;
ALTER TABLE orders_results.orders ADD COLUMN sample_date_time time NULL;
ALTER TABLE orders_results.orders RENAME COLUMN sample_date TO sample_date_temp;

-- +migrate Down
ALTER TABLE orders_results.orders DROP COLUMN sample_date_date;
ALTER TABLE orders_results.orders DROP COLUMN sample_date_time;
ALTER TABLE orders_results.orders RENAME COLUMN sample_date_temp TO sample_date;