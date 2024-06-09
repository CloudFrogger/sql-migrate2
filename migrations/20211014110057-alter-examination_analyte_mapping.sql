-- +migrate Up
alter table orders_results.examination_analyte_mapping add COLUMN prior_source_type INT2 default NULL;

-- +migrate Down
alter table orders_results.examination_analyte_mapping drop COLUMN if exists prior_source_type;