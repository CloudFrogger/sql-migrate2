
-- +migrate Up

CREATE TABLE orders_results.order_note (
    id UUID NOT NULL DEFAULT UUID_GENERATE_V4(),
    order_id UUID NOT NULL,
    note VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT TIMEZONE('UTC'::TEXT, NOW()),
    created_by UUID NOT NULL,
    CONSTRAINT order_note_pk PRIMARY KEY (id),
    CONSTRAINT fk_order_note__order_id FOREIGN KEY (order_id) REFERENCES orders_results.orders (id)
);

CREATE INDEX IF NOT EXISTS idx_order_note__order_id
    ON orders_results.order_note USING BTREE (order_id);

-- +migrate Down

DROP TABLE orders_results.order_note;