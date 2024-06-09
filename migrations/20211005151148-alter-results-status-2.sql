-- +migrate Up

update orders_results.results r
set status_type =
        (select name from orders_results.result_status_types where id = r.status_type_id);

-- +migrate Down

update orders_results.results r
set status_type_id =
        (select id from orders_results.result_status_types where name = r.status_type);