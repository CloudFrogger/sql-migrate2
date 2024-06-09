
-- +migrate Up
CREATE TABLE IF NOT EXISTS orders_results.websync_orders_protocol (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    order_id uuid not null,
    material_id uuid not null,
    examination_id uuid not null,
    analyte_id uuid not null,
    ordered_sample_id uuid not null,
    websync_link_id uuid not null,
    created timestamp not null default (now() at time zone 'utc')
);
-- +migrate Down
DROP Table orders_results.websync_orders_protocol;
