
-- +migrate Up
delete from orders_results.extra_values_ordered_examination_analytes where key is null or value is null;
delete from orders_results.extra_values where key is null or value is null;

alter table orders_results.extra_values_ordered_examination_analytes alter column key set not null;
alter table orders_results.extra_values_ordered_examination_analytes alter column value set not null;
alter table orders_results.extra_values alter column key set not null;
alter table orders_results.extra_values alter column value set not null;

-- +migrate Down

alter table orders_results.extra_values_ordered_examination_analytes alter column key drop not null;
alter table orders_results.extra_values_ordered_examination_analytes alter column value drop not null;
alter table orders_results.extra_values alter column key drop not null;
alter table orders_results.extra_values alter column value drop not null;
