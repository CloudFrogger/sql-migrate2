
-- +migrate Up

CREATE TABLE orders_results.subjects (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	laboratory_id uuid NOT NULL,
	subject_type varchar NOT NULL,
	created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
	modified_at timestamp NULL,
	deleted_at timestamp NULL
);
ALTER TABLE orders_results.subjects ADD CONSTRAINT subjects_pk PRIMARY KEY (id);



CREATE TABLE orders_results.subjects_personal_details (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	subject_id uuid NOT NULL,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	date_of_birth timestamp NULL,
	gender varchar(20) NOT NULL,
	address varchar NULL,
	postcode varchar(50) NULL,
	city varchar NULL,
	country varchar(255) NULL,
	phone_number_primary varchar NOT NULL,
	phone_number_secondary varchar NULL
);
ALTER TABLE orders_results.subjects_personal_details ADD CONSTRAINT subjects_personal_details_pk PRIMARY KEY (id);
ALTER TABLE orders_results.subjects_personal_details ADD CONSTRAINT fk_subject FOREIGN KEY (subject_id) REFERENCES orders_results.subjects(id);
ALTER TABLE orders_results.subjects_personal_details ADD CONSTRAINT fk_gender FOREIGN KEY (gender) REFERENCES orders_results.gender_definition(gender);



CREATE TABLE orders_results.subjects_donor_details (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	subject_id uuid NOT NULL,
	donor_id varchar NOT NULL,
	date_of_birth timestamp NULL,
	gender varchar NOT NULL,
	blood_type varchar(10) NULL,
	cde varchar NULL,
	kell varchar NULL,
	rhesusfactor varchar NULL DEFAULT ''::character varying
);
ALTER TABLE orders_results.subjects_donor_details ADD CONSTRAINT subjects_donor_details_pk PRIMARY KEY (id);
ALTER TABLE orders_results.subjects_donor_details ADD CONSTRAINT fk_subject FOREIGN KEY (subject_id) REFERENCES orders_results.subjects(id);
ALTER TABLE orders_results.subjects_donor_details ADD CONSTRAINT fk_gender FOREIGN KEY (gender) REFERENCES orders_results.gender_definition(gender);



CREATE TABLE orders_results.subjects_pseudonym_details (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	subject_id uuid NOT NULL,
	pseudonym varchar NOT NULL,
	date_of_birth timestamp NULL,
	gender varchar NULL,
	customer_facility_id uuid NOT NULL
);
ALTER TABLE orders_results.subjects_pseudonym_details ADD CONSTRAINT subjects_pseudonym_details_pk PRIMARY KEY (id);
ALTER TABLE orders_results.subjects_pseudonym_details ADD CONSTRAINT fk_subject FOREIGN KEY (subject_id) REFERENCES orders_results.subjects(id);
ALTER TABLE orders_results.subjects_pseudonym_details ADD CONSTRAINT fk_gender FOREIGN KEY (gender) REFERENCES orders_results.gender_definition(gender);

-- +migrate Down

DROP TABLE ORDERS_RESULTS.SUBJECTS_DONOR_DETAILS CASCADE;

DROP TABLE ORDERS_RESULTS.SUBJECTS_PERSONAL_DETAILS CASCADE;

DROP TABLE ORDERS_RESULTS.SUBJECTS_PSEUDONYM_DETAILS CASCADE;

DROP TABLE ORDERS_RESULTS.SUBJECTS CASCADE;