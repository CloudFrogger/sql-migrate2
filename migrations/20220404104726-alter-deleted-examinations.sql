
-- +migrate Up
alter table orders_results.examinations add column deleted_at timestamp null;
UPDATE orders_results.examinations SET deleted_at = NOW() WHERE deleted = true;
alter table orders_results.examinations drop column if exists deleted;

alter table orders_results.examination_analyte_mapping add column deleted_at timestamp null;
UPDATE orders_results.examination_analyte_mapping SET deleted_at = NOW() WHERE deleted = true;
alter table orders_results.examination_analyte_mapping drop column if exists deleted;

-- +migrate Down
alter table orders_results.examinations add column deleted bool default false;
UPDATE orders_results.examinations SET deleted = true WHERE deleted_at IS NOT NULL;
alter table orders_results.examinations drop column if exists deleted_at;

alter table orders_results.examination_analyte_mapping add column deleted bool default false;
UPDATE orders_results.examination_analyte_mapping SET deleted = true WHERE deleted_at IS NOT NULL;
alter table orders_results.examination_analyte_mapping drop column if exists deleted_at;