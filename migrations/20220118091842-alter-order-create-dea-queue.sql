-- +migrate Up
CREATE TABLE orders_results.dea_queue
(
    order_id uuid not null unique,
    busy bool default false,
    created_at timestamp default (now() at time zone 'utc'),
    modified_at timestamp,
    CONSTRAINT pk_dea_queue primary key (order_id)
);

ALTER TABLE orders_results.orders ADD COLUMN IF NOT EXISTS document_id uuid;
ALTER TABLE orders_results.orders ADD COLUMN IF NOT EXISTS is_printed bool;
ALTER TABLE orders_results.orders ADD COLUMN IF NOT EXISTS print_date timestamp;
-- +migrate Down
Drop TABLE orders_results.dea_queue;

ALTER TABLE orders_results.orders DROP COLUMN IF EXISTS document_id;
ALTER TABLE orders_results.orders DROP COLUMN IF EXISTS is_printed;
ALTER TABLE orders_results.orders DROP COLUMN IF EXISTS print_date;
