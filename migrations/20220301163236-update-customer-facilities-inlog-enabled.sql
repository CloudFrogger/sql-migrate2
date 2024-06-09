
-- +migrate Up
update orders_results.customer_facilities set is_inlog_enabled = true where code like '7%' or code like '6%' or code in ('101','105','851','852','855');;
-- +migrate Down
update orders_results.customer_facilities set is_inlog_enabled = false;
