
-- +migrate Up
ALTER TABLE orders_results.orders
ADD COLUMN eia_reference_id uuid default(NULL);

-- +migrate Down
ALTER TABLE orders_results.orders
DROP COLUMN eia_reference_id;