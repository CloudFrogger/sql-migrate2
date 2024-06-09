
-- +migrate Up
CREATE INDEX idx_eia_transfer_history_order_id ON orders_results.eia_transfer_history(order_id);

-- +migrate Down
DROP INDEX orders_results.idx_eia_transfer_history_order_id;
