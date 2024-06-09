
-- +migrate Up
ALTER TABLE orders_results.customer_facilities ALTER COLUMN primary_notification_email SET NOT NULL;
ALTER TABLE orders_results.customer_facilities ALTER COLUMN primary_notification_email SET DEFAULT '';

ALTER TABLE orders_results.customer_facilities ALTER COLUMN primary_laboratory SET NOT NULL;
ALTER TABLE orders_results.customer_facilities ALTER COLUMN primary_laboratory SET DEFAULT '';

ALTER TABLE orders_results.customer_facilities ALTER COLUMN is_inlog_enabled SET NOT NULL;
ALTER TABLE orders_results.customer_facilities ALTER COLUMN is_inlog_enabled SET DEFAULT false;

-- +migrate Down
ALTER TABLE orders_results.customer_facilities ALTER COLUMN primary_notification_email DROP NOT NULL;
ALTER TABLE orders_results.customer_facilities ALTER COLUMN primary_laboratory DROP NOT NULL;
ALTER TABLE orders_results.customer_facilities ALTER COLUMN is_inlog_enabled DROP NOT NULL;
