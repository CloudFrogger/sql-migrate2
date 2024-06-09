
-- +migrate Up
UPDATE orders_results.customer_facilities SET primary_notification_email = '' WHERE primary_notification_email IS NULL;
UPDATE orders_results.customer_facilities SET primary_laboratory = '' WHERE primary_laboratory IS NULL;
UPDATE orders_results.customer_facilities SET is_inlog_enabled = false WHERE is_inlog_enabled IS NULL;

-- +migrate Down
