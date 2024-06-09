
-- +migrate Up
ALTER TABLE orders_results.ordered_examination_analytes
    ADD COLUMN analyte_id_uuid uuid default(null);

UPDATE orders_results.ordered_examination_analytes
SET analyte_id_uuid = analyte_id::uuid;

ALTER TABLE orders_results.ordered_examination_analytes
    ALTER COLUMN analyte_id_uuid SET NOT NULL;

ALTER TABLE orders_results.ordered_examination_analytes
DROP COLUMN analyte_id;

ALTER TABLE orders_results.ordered_examination_analytes
    RENAME COLUMN analyte_id_uuid TO analyte_id;

-- +migrate Down
ALTER TABLE orders_results.ordered_examination_analytes
    ADD COLUMN analyte_id_vc varchar default(null);

UPDATE orders_results.ordered_examination_analytes
SET analyte_id_vc = analyte_id::varchar;

ALTER TABLE orders_results.ordered_examination_analytes
    ALTER COLUMN analyte_id_vc SET NOT NULL;

ALTER TABLE orders_results.ordered_examination_analytes
DROP COLUMN analyte_id;

ALTER TABLE orders_results.ordered_examination_analytes
    RENAME COLUMN analyte_id_vc TO analyte_id;