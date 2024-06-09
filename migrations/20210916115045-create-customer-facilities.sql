-- +migrate Up
CREATE TABLE orders_results.customer_facilities
(
    id                         UUID      NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    code                       varchar   not null UNIQUE,
    name                       varchar   not null,
    short_name                 varchar   not null,
    address                    varchar   not null,
    zip                        varchar,
    city                       varchar,
    country                    varchar,
    primary_notification_email varchar,
    primary_laboratory         varchar,
    has_external_ref           boolean            default false,
    has_sample_code            boolean            default false,
    download_link_enabled      boolean            default false,
    allow_custom_sample_codes  boolean            default false,
    is_primary_facility        boolean            default false,
    custom_sample_code_prefix  varchar            default '',
    notification_minutes       int                default 0,
    deleted_at                 timestamp null,
    modified_at                timestamp null,
    created_at                 timestamp NOT null default (now() at time zone 'utc')
);

ALTER TABLE orders_results.orders
    ADD COLUMN customer_facility_id UUID references orders_results.customer_facilities (id);

-- +migrate Down

ALTER TABLE orders_results.orders DROP COLUMN IF EXISTS customer_facility_id;
DROP TABLE orders_results.customer_facilities CASCADE;

