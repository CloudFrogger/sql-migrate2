-- +migrate Up
CREATE TABLE orders_results.orders_document_history
(
    id            UUID      NOT NULL unique DEFAULT uuid_generate_v4(),
    name          varchar   not null,
    order_id      uuid      not null,
    document_id   uuid      not null,
    version       int       not null        default 1,
    archive_until timestamp not null,
    deleted_at    timestamp null,
    modified_at   timestamp null,
    created_at    timestamp NOT null        default (now() at time zone 'utc'),
    CONSTRAINT pk_orders_document_history primary key (id),
    CONSTRAINT orders_document_history_order_id FOREIGN KEY (order_id) REFERENCES orders_results.orders (id)
);
-- +migrate Down


DROP TABLE orders_results.orders_document_history;