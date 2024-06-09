
-- +migrate Up
DROP TABLE orders_results.orders_filter;

-- +migrate Down

CREATE TABLE IF NOT EXISTS orders_results.orders_filter (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    order_id uuid not null,
    searchvalue varchar not null,
    searchtype varchar not null
    );
CREATE INDEX searchvalue_order_id_orders_filter_IDX on orders_results.orders_filter (order_id, searchvalue);