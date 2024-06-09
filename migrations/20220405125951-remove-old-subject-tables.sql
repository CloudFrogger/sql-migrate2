
-- +migrate Up

drop table orders_results.subjects_donor;
drop table orders_results.subjects_personal;
drop table orders_results.subjects_pseudonym;

-- +migrate Down

CREATE TABLE orders_results.subjects_donor (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	order_id uuid NOT NULL,
	donor_id varchar NOT NULL,
	donation_id varchar NOT NULL,
	date_of_birth timestamp NULL,
	gender varchar(20) NOT NULL,
	blood_type varchar(10) NULL,
	cde varchar NULL,
	kell varchar NULL,
	created_at timestamp NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
	modified_at timestamp NULL,
	rhesusfactor varchar NULL DEFAULT ''::character varying,
	deleted_at timestamp NULL,
	donation_type text NULL,
	CONSTRAINT subjects_donor_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX subject_donor_order_id ON orders_results.subjects_donor USING btree (order_id);
ALTER TABLE orders_results.subjects_donor ADD CONSTRAINT subjects_donor_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders_results.orders(id);


CREATE TABLE orders_results.subjects_personal (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	order_id uuid NOT NULL,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	date_of_birth timestamp NULL,
	gender varchar(20) NOT NULL,
	address varchar NULL,
	postcode varchar(50) NULL,
	city varchar NULL,
	country varchar(255) NULL,
	phone_number_primary varchar NOT NULL,
	phone_number_secondary varchar NULL,
	created_at timestamp NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
	modified_at timestamp NULL,
	deleted_at timestamp NULL,
	CONSTRAINT subjects_personal_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX subject_personal_order_id ON orders_results.subjects_personal USING btree (order_id);
ALTER TABLE orders_results.subjects_personal ADD CONSTRAINT fk_gender FOREIGN KEY (gender) REFERENCES orders_results.gender_definition(gender);
ALTER TABLE orders_results.subjects_personal ADD CONSTRAINT subjects_personal_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders_results.orders(id);


CREATE TABLE orders_results.subjects_pseudonym (
	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	order_id uuid NOT NULL,
	pseudonym varchar NOT NULL,
	date_of_birth timestamp NULL,
	gender varchar(20) NULL,
	created_at timestamp NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
	modified_at timestamp NULL,
	deleted_at timestamp NULL,
	CONSTRAINT subjects_pseudonym_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX subject_pseudonym_order_id ON orders_results.subjects_pseudonym USING btree (order_id);
ALTER TABLE orders_results.subjects_pseudonym ADD CONSTRAINT subjects_pseudonym_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders_results.orders(id);


INSERT INTO orders_results.subjects_donor
(id, order_id, donor_id, donation_id, date_of_birth, gender, blood_type, cde, kell, created_at, modified_at, rhesusfactor, deleted_at, donation_type)
select uuid_generate_v4(), o.id, donor_id, donation_id, date_of_birth, gender, blood_type, cde, kell, s.created_at, s.modified_at, rhesusfactor, s.deleted_at, o.donation_type
from orders_results.subjects s 
inner join orders_results.subjects_donor_details sd on s.id = sd.subject_id 
inner join orders_results.orders o on o.subject_id = s.id
where s.subject_type = 'DONOR';

INSERT INTO orders_results.subjects_personal
(id, order_id, first_name, last_name, date_of_birth, gender, address, postcode, city, country, phone_number_primary, phone_number_secondary, created_at, modified_at, deleted_at)
select uuid_generate_v4(), o.id, first_name, last_name, date_of_birth, gender, address, postcode, city, country, phone_number_primary, phone_number_secondary, o.created_at, s.modified_at, s.deleted_at
from orders_results.subjects s 
inner join orders_results.subjects_personal_details sd on s.id = sd.subject_id 
inner join orders_results.orders o on o.subject_id = s.id
where s.subject_type = 'PERSONAL';

INSERT INTO orders_results.subjects_pseudonym
(id, order_id, pseudonym, date_of_birth, gender, created_at, modified_at, deleted_at)
select uuid_generate_v4(), o.id, pseudonym, date_of_birth, gender, s.created_at, s.modified_at, s.deleted_at
from orders_results.subjects s 
inner join orders_results.subjects_pseudonym_details sd on s.id = sd.subject_id 
inner join orders_results.orders o on o.subject_id = s.id
where s.subject_type = 'PSEUDONYMIZED';