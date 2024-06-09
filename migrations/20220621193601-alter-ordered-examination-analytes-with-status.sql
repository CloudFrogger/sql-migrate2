
-- +migrate Up
ALTER TABLE orders_results.ordered_examination_analytes ADD status VARCHAR(50) NOT NULL DEFAULT 'initial';

-- +migrate Down
ALTER TABLE orders_results.ordered_examination_analytes DROP COLUMN status;
