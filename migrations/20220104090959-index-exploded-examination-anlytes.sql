
-- +migrate Up
CREATE INDEX idx_exploded_examination_analytes_sample_id ON orders_results.ordered_examination_analytes (ordered_sample_id ASC);
-- +migrate Down
DROP INDEX if exists orders_results.idx_exploded_examination_analytes_sample_id;