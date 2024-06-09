
-- +migrate Up
ALTER TABLE orders_results.ordered_samples ALTER COLUMN order_id DROP NOT NULL;
ALTER TABLE orders_results.ordered_samples ALTER COLUMN material_id DROP NOT NULL;
ALTER TABLE orders_results.ordered_samples ALTER COLUMN mapped_material DROP NOT NULL;

-- +migrate Down
ALTER TABLE orders_results.ordered_samples ALTER COLUMN order_id SET NOT NULL;
ALTER TABLE orders_results.ordered_samples ALTER COLUMN material_id SET NOT NULL;
ALTER TABLE orders_results.ordered_samples ALTER COLUMN mapped_material SET NOT NULL;