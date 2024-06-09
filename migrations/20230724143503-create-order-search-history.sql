
-- +migrate Up
CREATE TABLE orders_results.orders_search_history (
	id uuid NOT NULL,
	laboratory_id uuid NOT NULL,
	user_id uuid NOT NULL,
	order_id uuid NOT NULL,
	created_at timestamp NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
	CONSTRAINT orders_search_history_pk PRIMARY KEY (id),
	CONSTRAINT orders_search_history_un UNIQUE (user_id, order_id)
);
CREATE INDEX orders_search_history_laboratory_user_idx ON orders_results.orders_search_history USING btree (laboratory_id, user_id);
ALTER TABLE orders_results.orders_search_history ADD CONSTRAINT orders_search_history_fk FOREIGN KEY (order_id) REFERENCES orders_results.orders(id);

-- +migrate Down
DROP TABLE orders_results.orders_search_history;