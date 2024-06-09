
-- +migrate Up
CREATE UNIQUE INDEX idx_extra_values_result_id_key_unique ON orders_results.extra_values(result_id,key);

-- +migrate Down
DROP INDEX orders_results.idx_extra_values_result_id_key_unique;