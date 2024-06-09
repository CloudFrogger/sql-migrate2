-- +migrate Up
alter table orders_results.subjects_donor add column donation_type text null;

alter table orders_results.orders ALTER COLUMN customer_facility_id SET not null;
-- +migrate Down
alter table orders_results.subjects_donor drop column if exists donation_type;
