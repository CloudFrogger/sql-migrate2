-- +migrate Up
UPDATE orders_results.results r
SET result_type = (
    SELECT type FROM orders_results.result_value_types rvt WHERE rvt.id = r.result_type_id
);

-- +migrate Down

update orders_results.results r
set result_type_id =
        (select id from orders_results.result_value_types where type = r.result_type);