
-- +migrate Up
ALTER TABLE orders_results.results DROP COLUMN parent_result_id;

-- +migrate Down
ALTER TABLE orders_results.results
    ADD parent_result_id uuid NULL CONSTRAINT fk_results_parent_result_id REFERENCES orders_results.results (id);