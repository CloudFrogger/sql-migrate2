
-- +migrate Up
alter table orders_results.ordered_examination_analytes add column inducer_id uuid null references orders_results.ordered_examination_analytes(id);

-- +migrate Down
alter table orders_results.ordered_examination_analytes drop column if exists inducer_id;
