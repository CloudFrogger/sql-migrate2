
-- +migrate Up
CREATE TABLE IF NOT EXISTS orders_results.orders (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    laboratory_id varchar(40) not null,
    order_type varchar(20) not null,
    sample_date timestamp not null,
    facility_code varchar(128) not null,
    facility_name varchar(128) not null,
    external_reference varchar(128) not null,
    can_update_subject boolean default true,
    can_update_material boolean default true,
    status varchar(20) not null,
    created_at timestamp not null default (now() at time zone 'utc'),
    modified_at timestamp,
    modified_by varchar,
    deleted boolean default false
);


CREATE TABLE IF NOT EXISTS orders_results.subjects_personal (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    order_id uuid NOT NULL REFERENCES orders_results.orders (id),
    first_name varchar not null,
    last_name varchar not null,
    date_of_birth timestamp not null,
    gender varchar(20) not null,
    address varchar,
    postcode varchar(50),
    city varchar,
    country varchar(255),
    phone_number_primary varchar not null,
    phone_number_secondary varchar,
    created_at timestamp not null default (now() at time zone 'utc'),
    modified_at timestamp,
    modified_by varchar,
    deleted boolean default false
);

CREATE TABLE IF NOT EXISTS orders_results.subjects_donor(
    id uuid default uuid_generate_v4() PRIMARY KEY,
    order_id uuid NOT NULL REFERENCES orders_results.orders (id),
    donor_id varchar not null,
    donation_id varchar not null,
    date_of_birth timestamp not null,
    gender varchar not null,
    blood_type varchar(10),
    cdde varchar,
    kell varchar,
    created_at timestamp not null default (now() at time zone 'utc'),
    modified_at timestamp,
    modified_by varchar,
    deleted boolean default false
);


CREATE TABLE IF NOT EXISTS orders_results.ordered_samples (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    order_id uuid NOT NULL REFERENCES orders_results.orders (id),
    material_id uuid NOT NULL,
    sample_code varchar NOT NULL,
    delete boolean default false
);

-- +migrate Down

DROP TABLE IF EXISTS orders_results.ordered_samples;
DROP TABLE IF EXISTS orders_results.subjects_personal;
DROP TABLE IF EXISTS orders_results.subjects_donor;
DROP TABLE IF EXISTS orders_results.orders;