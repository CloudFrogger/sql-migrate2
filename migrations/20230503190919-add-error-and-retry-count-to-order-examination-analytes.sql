
-- +migrate Up
ALTER TABLE orders_results.ordered_examination_analytes
ADD COLUMN error varchar DEFAULT(NULL);

ALTER TABLE orders_results.ordered_examination_analytes
ADD COLUMN retry_count int NOT NULL DEFAULT(0);

-- +migrate Down

ALTER TABLE orders_results.ordered_examination_analytes
DROP COLUMN error;

ALTER TABLE orders_results.ordered_examination_analytes
DROP COLUMN retry_count;