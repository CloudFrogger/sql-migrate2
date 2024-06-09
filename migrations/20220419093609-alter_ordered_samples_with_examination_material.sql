
-- +migrate Up
ALTER TABLE orders_results.ordered_samples ADD examination_id UUID NULL;
UPDATE orders_results.ordered_samples os SET examination_id=(SELECT examination_id FROM orders_results.ordered_examination_analytes WHERE ordered_sample_id=os.id LIMIT 1);

ALTER TABLE orders_results.ordered_samples ALTER COLUMN examination_id SET NOT NULL;
ALTER TABLE orders_results.ordered_samples ADD CONSTRAINT ordered_samples_examination_fk FOREIGN KEY (examination_id) REFERENCES orders_results.examinations(id);

ALTER TABLE orders_results.ordered_samples ADD mapped_material SMALLINT NULL;
UPDATE orders_results.ordered_samples SET mapped_material=1;
ALTER TABLE orders_results.ordered_samples ALTER COLUMN mapped_material SET NOT NULL;

-- +migrate Down
ALTER TABLE orders_results.ordered_samples DROP COLUMN examination_id;
ALTER TABLE orders_results.ordered_samples DROP COLUMN mapped_material;
