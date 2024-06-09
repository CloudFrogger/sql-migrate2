
-- +migrate Up
-- orders_results.orders_history definition
CREATE TABLE orders_results.orders_history (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	order_id uuid NOT NULL,
	date timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
	source_name varchar NULL,
	order_status varchar NULL,
	CONSTRAINT orders_history_pk PRIMARY KEY (id)
);

-- orders_results.orders_history foreign key
ALTER TABLE orders_results.orders_history ADD CONSTRAINT orders_history_fk FOREIGN KEY (order_id) REFERENCES orders_results.orders(id);

-- +migrate Down
DROP TABLE orders_results.orders_history;
