
-- +migrate Up
ALTER TABLE orders_results.results
ADD COLUMN workitem_result_id uuid default(null);

CREATE UNIQUE INDEX idx_results_workitem_result_id_unique ON orders_results.results(workitem_result_id) WHERE workitem_result_id IS NOT NULL;

-- +migrate Down
DROP INDEX orders_results.idx_results_workitem_result_id_unique;

ALTER TABLE orders_results.results
DROP COLUMN workitem_result_id;