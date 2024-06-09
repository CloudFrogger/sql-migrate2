
-- +migrate Up
ALTER TABLE orders_results.subjects_donor RENAME COLUMN cdde TO cde;
ALTER TABLE orders_results.subjects_donor ADD COLUMN rhesusfactor  varchar default '';
-- +migrate Down
ALTER TABLE orders_results.subjects_donor RENAME COLUMN cde TO cdde;
ALTER TABLE orders_results.subjects_donor DROP COLUMN IF EXISTS rhesusfactor;