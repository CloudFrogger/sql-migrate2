
-- +migrate Up
ALTER TABLE orders_results.results
ADD COLUMN workitem_id_uuid uuid default(null);

UPDATE orders_results.results
SET workitem_id_uuid = workitem_id::uuid;

ALTER TABLE orders_results.results
ALTER COLUMN workitem_id_uuid SET NOT NULL;

ALTER TABLE orders_results.results
DROP COLUMN workitem_id;

ALTER TABLE orders_results.results
RENAME COLUMN workitem_id_uuid TO workitem_id;

-- +migrate Down
ALTER TABLE orders_results.results
ADD COLUMN workitem_id_vc varchar default(null);

UPDATE orders_results.results
SET workitem_id_vc = workitem_id::varchar;

ALTER TABLE orders_results.results
ALTER COLUMN workitem_id_vc SET NOT NULL;

ALTER TABLE orders_results.results
DROP COLUMN workitem_id;

ALTER TABLE orders_results.results
RENAME COLUMN workitem_id_vc TO workitem_id;