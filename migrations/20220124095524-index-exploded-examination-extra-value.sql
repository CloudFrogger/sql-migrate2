
-- +migrate Up
CREATE INDEX idx_extra_value_exploded_examination_analyte_id ON orders_results.extra_values_ordered_examination_analytes (examination_analyte_id ASC);
-- +migrate Down
DROP INDEX if exists orders_results.idx_extra_value_exploded_examination_analyte_id;