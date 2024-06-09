
-- +migrate Up
ALTER TABLE orders_results.examinations
ADD COLUMN name varchar not null default('');

UPDATE orders_results.examinations
SET name = description;

UPDATE orders_results.examinations
SET description = null;

-- +migrate Down

UPDATE orders_results.examinations
SET description = name;

ALTER TABLE orders_results.examinations
DROP COLUMN name;

