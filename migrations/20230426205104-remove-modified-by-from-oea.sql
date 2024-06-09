
-- +migrate Up
alter table orders_results.ordered_examination_analytes
drop column modified_by;

-- +migrate Down
alter table orders_results.ordered_examination_analytes
add column modified_by varchar;