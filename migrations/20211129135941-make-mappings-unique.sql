
-- +migrate Up
ALTER TABLE orders_results.customer_facility_user_mappings
ADD CONSTRAINT unique_userid_facilityid UNIQUE (user_id, customer_facility_id);

-- +migrate Down
ALTER TABLE orders_results.customer_facility_user_mappings
DROP CONSTRAINT unique_userid_facilityid;