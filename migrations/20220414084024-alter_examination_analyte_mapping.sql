
-- +migrate Up
ALTER TABLE orders_results.examination_analyte_mapping ADD mapped_material SMALLINT NULL;
UPDATE orders_results.examination_analyte_mapping SET mapped_material=1;
ALTER TABLE orders_results.examination_analyte_mapping ALTER COLUMN mapped_material SET NOT NULL;

-- +migrate Down
ALTER TABLE orders_results.examination_analyte_mapping DROP COLUMN mapped_material;
