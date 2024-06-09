
-- +migrate Up

CREATE TABLE IF NOT EXISTS orders_results.subjects_pseudonym(
    id uuid default uuid_generate_v4() PRIMARY KEY,
    order_id uuid NOT NULL REFERENCES orders_results.orders (id),
    pseudonym varchar not null,
    date_of_birth timestamp,
    gender varchar,
    created_at timestamp not null default (now() at time zone 'utc'),
    modified_at timestamp,
    modified_by varchar,
    deleted boolean default false
    );

-- +migrate Down

DROP TABLE orders_results.subjects_pseudonym CASCADE;
