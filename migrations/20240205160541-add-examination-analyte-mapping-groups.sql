
-- +migrate Up
ALTER TABLE orders_results.examination_analyte_mapping ADD "group" varchar NULL;

-- +migrate Down
ALTER TABLE orders_results.examination_analyte_mapping DROP COLUMN "group";
