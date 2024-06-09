
-- +migrate Up
alter table orders_results.orders drop column if exists can_update_subject;
alter table orders_results.orders drop column if exists can_update_material;
alter table orders_results.orders drop column if exists facility_code;
alter table orders_results.orders drop column if exists facility_name;

alter table orders_results.orders add column deleted_at timestamp null;
UPDATE orders_results.orders SET deleted_at = NOW() WHERE deleted = true;
alter table orders_results.orders drop column if exists deleted;

alter table orders_results.subjects_donor add column deleted_at timestamp null;
UPDATE orders_results.subjects_donor SET deleted_at = NOW() WHERE deleted = true;
alter table orders_results.subjects_personal add column deleted_at timestamp null;
UPDATE orders_results.subjects_personal SET deleted_at = NOW() WHERE deleted = true;
alter table orders_results.subjects_pseudonym add column deleted_at timestamp null;
UPDATE orders_results.subjects_pseudonym SET deleted_at = NOW() WHERE deleted = true;

alter table orders_results.subjects_donor drop column if exists deleted;
alter table orders_results.subjects_personal drop column if exists deleted;
alter table orders_results.subjects_pseudonym drop column if exists deleted;

alter table orders_results.ordered_samples add column deleted_at timestamp null;
UPDATE orders_results.ordered_samples SET deleted_at = NOW() WHERE delete = true;
alter table orders_results.ordered_samples drop column if exists delete;

-- +migrate Down
alter table orders_results.orders add column can_update_subject bool default false;
alter table orders_results.orders add column can_update_material bool default false;
alter table orders_results.orders add column facility_name text;
alter table orders_results.orders add column facility_code text;
alter table orders_results.orders add column deleted bool default false;
UPDATE orders_results.orders SET deleted = true WHERE deleted_at is not null;
alter table orders_results.orders drop column if exists deleted_at;


alter table orders_results.subjects_donor add column deleted bool default false;
UPDATE orders_results.subjects_donor SET deleted = true WHERE deleted_at is not null;
alter table orders_results.subjects_personal add column deleted bool default false;
UPDATE orders_results.subjects_personal SET deleted = true WHERE deleted_at is not null;
alter table orders_results.subjects_pseudonym add column deleted bool default false;
UPDATE orders_results.subjects_pseudonym SET deleted = true WHERE deleted_at is not null;

alter table orders_results.subjects_donor drop column if exists deleted_at;
alter table orders_results.subjects_personal drop column if exists deleted_at;
alter table orders_results.subjects_pseudonym drop column if exists deleted_at;

alter table orders_results.ordered_samples add column delete bool default false;
UPDATE orders_results.ordered_samples SET delete = true  WHERE deleted_at is not null;
alter table orders_results.ordered_samples drop column if exists deleted_at;