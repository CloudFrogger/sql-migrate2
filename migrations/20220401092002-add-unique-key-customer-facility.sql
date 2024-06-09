
-- +migrate Up
ALTER TABLE orders_results.customer_facilities ADD COLUMN laboratory_id uuid;
UPDATE orders_results.customer_facilities c SET laboratory_id = cast(primary_laboratory as uuid)  where laboratory_id is null;

ALTER TABLE orders_results.customer_facilities ADD CONSTRAINT unique_code_laboratory UNIQUE(code, laboratory_id);
ALTER TABLE orders_results.customer_facilities ALTER COLUMN laboratory_id SET NOT NULL;
ALTER TABLE orders_results.customer_facilities DROP COLUMN primary_laboratory;
ALTER TABLE orders_results.customer_facilities DROP CONSTRAINT customer_facilities_code_key;
-- +migrate Down
ALTER TABLE orders_results.customer_facilities DROP CONSTRAINT unique_code_laboratory;
ALTER TABLE orders_results.customer_facilities ADD COLUMN  primary_laboratory varchar default '';
UPDATE orders_results.customer_facilities c SET primary_laboratory = cast(laboratory_id as varchar)  where primary_laboratory = '';
ALTER TABLE orders_results.customer_facilities DROP COLUMN laboratory_id;
ALTER TABLE orders_results.customer_facilities ADD CONSTRAINT customer_facilities_code_key UNIQUE(code);