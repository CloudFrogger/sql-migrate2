
-- +migrate Up
create table orders_results.customer_facility_user_mappings (
    id uuid not null default uuid_generate_v4(),
    user_id uuid not null,
    customer_facility_id uuid not null,
    is_primary bool not null,
    constraint pk_customer_facility_user_mappings primary key(id),
    constraint fk_customer_facility_id_customer_facilities foreign key(customer_facility_id) references orders_results.customer_facilities(id)
);

-- +migrate Down
drop table orders_results.customer_facility_user_mappings;
