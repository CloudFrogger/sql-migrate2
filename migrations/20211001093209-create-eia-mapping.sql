-- +migrate Up
CREATE TABLE orders_results.eia_mapping
(
    id          UUID      NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    service     varchar   not null,
    url         varchar   not null,
    deleted_at  timestamp null,
    modified_at timestamp null,
    created_at  timestamp NOT null default (now() at time zone 'utc')
);

Insert INTO orders_results.eia_mapping(service, url) VALUES('INLOG interface', 'http://inloginterface/v1/int/result');

-- +migrate Down

DROP TABLE orders_results.eia_mapping;