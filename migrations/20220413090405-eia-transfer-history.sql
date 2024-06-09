-- +migrate Up
CREATE TABLE orders_results.eia_transfer_history
(
    id             uuid      NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_id       uuid      not null,
    eia_mapping_id uuid      not null,
    response_body  text               default '',
    status_code    int       not null,
    created_at     timestamp NOT null default (now() at time zone 'utc'),
    constraint fk_order__order_id foreign key (order_id) references orders_results.orders (id),
    constraint fk_eia_mapping__eia_mapping_id foreign key (eia_mapping_id) references orders_results.eia_mapping (id)
);

ALTER TABLE orders_results.orders DROP COLUMN transfer_eia_date;
-- +migrate Down
DROP TABLE orders_results.eia_transfer_history;
ALTER TABLE orders_results.orders Add COLUMN transfer_eia_date timestamp;