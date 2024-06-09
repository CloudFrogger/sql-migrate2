
-- +migrate Up
CREATE INDEX idx_ordered_examination_analytes_ordered_examination_id ON orders_results.ordered_examination_analytes (ordered_examination_id ASC);

-- +migrate Down
DROP INDEX if exists orders_results.idx_ordered_examination_analytes_ordered_examination_id;