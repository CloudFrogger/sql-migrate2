
-- +migrate Up
alter table orders_results.results add COLUMN  result_source varchar default 'instrument';
alter table orders_results.results add COLUMN  result_source_id varchar default '';
Alter table orders_results.results DROP CONSTRAINT if exists results_parent_result_id_fkey CASCADE;
Alter table orders_results.results DROP CONSTRAINT if exists fk_parent_result_id_ref_results CASCADE;

INSERT INTO
    orders_results.result_status_types (name)
VALUES
    ('INV');

-- +migrate Down
alter table orders_results.results DROP COLUMN result_source;
alter table orders_results.results DROP COLUMN result_source_id;

DELETE FROM orders_results.result_status_types WHERE name = 'INV';