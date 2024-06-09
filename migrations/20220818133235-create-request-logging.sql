-- +migrate Up
CREATE TABLE orders_results.http_request_log
(
    id                  uuid      NOT NULL DEFAULT uuid_generate_v4(),
    requested_url       text      not null,
    request_body        text      not null,
    response_body       text      not null,
    status_code         int       not null,
    direction           text      not null default 'out',
    interface_direction text      not null,
    created_at          timestamp NOT null default (now() at time zone 'utc')
);
-- +migrate Down
DROP TABLE orders_results.http_request_log;