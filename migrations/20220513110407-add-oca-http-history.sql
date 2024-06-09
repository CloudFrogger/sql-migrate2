
-- +migrate Up

CREATE TABLE IF NOT EXISTS orders_results.oca_http_history (
    id                      uuid not null default uuid_generate_v4(),
    order_id                uuid not null,
    type                    text default 'create_workitem',
    status_code             int  not null,
    response_body           text not null,
    request_data            text default '',
    created_at             timestamp     default timezone('utc', now()),
    constraint "pk_oca_http_history_id" PRIMARY KEY (id),
    constraint "fk_order_id__id" FOREIGN KEY (order_id) references orders_results.orders (id)
    );
-- +migrate Down
DROP TABLE orders_results.oca_http_history;