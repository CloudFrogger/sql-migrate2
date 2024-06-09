
-- +migrate Up
ALTER TABLE orders_results.orders ADD subject_id uuid NULL;
ALTER TABLE orders_results.orders ADD donation_id varchar NULL;
ALTER TABLE orders_results.orders ADD donation_type varchar NULL;
ALTER TABLE orders_results.orders ADD CONSTRAINT orders_subjects_fk FOREIGN KEY (subject_id) REFERENCES orders_results.subjects(id);

UPDATE
	ORDERS_RESULTS.ORDERS
SET
	SUBJECT_ID = 
(
	SELECT
		ID
	FROM
		ORDERS_RESULTS.SUBJECTS_DONOR SD
	WHERE
		SD.ORDER_ID = ORDERS_RESULTS.ORDERS.ID
UNION
	SELECT
		ID
	FROM
		ORDERS_RESULTS.SUBJECTS_PERSONAL SP
	WHERE
		SP.ORDER_ID = ORDERS_RESULTS.ORDERS.ID
UNION
	SELECT
		ID
	FROM
		ORDERS_RESULTS.SUBJECTS_PSEUDONYM SPS
	WHERE
		SPS.ORDER_ID = ORDERS_RESULTS.ORDERS.ID 
);

UPDATE
	ORDERS_RESULTS.ORDERS
SET
	(donation_id, donation_type) = 
	(
	SELECT
		donation_id, donation_type
	FROM
		ORDERS_RESULTS.SUBJECTS_DONOR SD
	WHERE
		SD.ORDER_ID = ORDERS_RESULTS.ORDERS.ID
);

-- +migrate Down
ALTER TABLE orders_results.orders DROP CONSTRAINT orders_subjects_fk;
ALTER TABLE orders_results.orders DROP COLUMN subject_id;
ALTER TABLE orders_results.orders DROP COLUMN donation_id;
ALTER TABLE orders_results.orders DROP COLUMN donation_type;
