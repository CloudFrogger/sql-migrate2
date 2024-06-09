
-- +migrate Up
TRUNCATE orders_results.orders CASCADE;
TRUNCATE orders_results.subjects_personal_details CASCADE;
TRUNCATE orders_results.subjects_donor_details CASCADE;
TRUNCATE orders_results.subjects_pseudonym_details CASCADE;
TRUNCATE orders_results.subjects CASCADE;

CREATE TABLE orders_results.orders_blood_donor_details (
   id uuid NOT NULL DEFAULT uuid_generate_v4(),
   order_id uuid NOT NULL,
   donor VARCHAR NOT NULL,
   donation VARCHAR NOT NULL,
   donation_type VARCHAR NOT NULL,
   blood_type VARCHAR NULL,
   cde VARCHAR NULL,
   kell VARCHAR NULL,
   rhesus_factor VARCHAR NULL,
   source VARCHAR NULL,
   CONSTRAINT pk_orders_blood_donor_details PRIMARY KEY (id),
   CONSTRAINT fk_orders_blood_donor_details_order FOREIGN KEY (order_id) REFERENCES orders_results.orders (id) ON DELETE CASCADE
);

ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN blood_type SET NOT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN blood_type SET DEFAULT ''::character varying;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN cde SET NOT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN cde SET DEFAULT ''::character varying;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN kell SET NOT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN kell SET DEFAULT ''::character varying;
ALTER TABLE orders_results.subjects_donor_details ADD created_at TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'utc');
ALTER TABLE orders_results.subjects_donor_details ADD deleted_at TIMESTAMP NULL;

ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN date_of_birth SET DATA TYPE DATE;
ALTER TABLE orders_results.subjects_personal_details ALTER COLUMN date_of_birth SET DATA TYPE DATE;
ALTER TABLE orders_results.subjects_pseudonym_details ALTER COLUMN date_of_birth SET DATA TYPE DATE;

ALTER TABLE orders_results.orders DROP COLUMN donation_id;
ALTER TABLE orders_results.orders DROP COLUMN donation_type;

ALTER TABLE orders_results.orders ADD subject_updated BOOLEAN NOT NULL DEFAULT FALSE;

-- +migrate Down
ALTER TABLE orders_results.orders DROP COLUMN subject_updated;

ALTER TABLE orders_results.orders ADD donation_id VARCHAR NULL;
ALTER TABLE orders_results.orders ADD donation_type VARCHAR NULL;

ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN date_of_birth SET DATA TYPE TIMESTAMP;
ALTER TABLE orders_results.subjects_personal_details ALTER COLUMN date_of_birth SET DATA TYPE TIMESTAMP;
ALTER TABLE orders_results.subjects_pseudonym_details ALTER COLUMN date_of_birth SET DATA TYPE TIMESTAMP;

ALTER TABLE orders_results.subjects_donor_details DROP COLUMN created_at;
ALTER TABLE orders_results.subjects_donor_details DROP COLUMN deleted_at;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN blood_type DROP NOT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN blood_type SET DEFAULT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN cde DROP NOT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN cde SET DEFAULT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN kell DROP NOT NULL;
ALTER TABLE orders_results.subjects_donor_details ALTER COLUMN kell SET DEFAULT NULL;

DROP TABLE orders_results.orders_blood_donor_details CASCADE;
