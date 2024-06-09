
-- +migrate Up
TRUNCATE TABLE orders_results.dea_queue;
ALTER TABLE orders_results.dea_queue ADD CONSTRAINT dea_queue_order_fk FOREIGN KEY (order_id) REFERENCES orders_results.orders(id);

-- +migrate Down
ALTER TABLE orders_results.dea_queue DROP CONSTRAINT dea_queue_order_fk;
