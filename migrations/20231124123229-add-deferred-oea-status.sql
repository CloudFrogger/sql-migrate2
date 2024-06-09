
-- +migrate Up
INSERT INTO orders_results.ordered_examination_analyte_status_types("type") VALUES('deferred');

-- +migrate Down
DELETE FROM orders_results.ordered_examination_analyte_status_types WHERE "type" = 'deferred';
