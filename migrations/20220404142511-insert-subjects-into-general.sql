
-- +migrate Up

update orders_results.subjects_donor
set gender = 'F'
where gender in ('w', 'W', 'f');

update orders_results.subjects_donor
set gender = 'M'
where gender in ('m');

update orders_results.subjects_donor
set gender = 'U'
where gender not in ('M', 'F', 'U');

alter table orders_results.subjects_donor
    add constraint fk_gender foreign key (gender) references orders_results.gender_definition (gender);


update orders_results.subjects_pseudonym
set gender = 'F'
where gender in ('w', 'W', 'f');

update orders_results.subjects_pseudonym
set gender = 'M'
where gender in ('m');

update orders_results.subjects_pseudonym
set gender = 'U'
where gender not in ('M', 'F', 'U');

alter table orders_results.subjects_pseudonym
    add constraint fk_gender foreign key (gender) references orders_results.gender_definition (gender);


INSERT INTO orders_results.subjects
(id, laboratory_id, subject_type, created_at, modified_at, deleted_at)
select s.id, cast(o.laboratory_id as uuid), 'PERSONAL', s.created_at ,s.modified_at, s.deleted_at from 
orders_results.subjects_personal s inner join orders_results.orders o on o.id = s.order_id;

INSERT INTO orders_results.subjects
(id, laboratory_id, subject_type, created_at, modified_at, deleted_at)
select s.id, cast(o.laboratory_id as uuid), 'DONOR', s.created_at ,s.modified_at, s.deleted_at from 
orders_results.subjects_donor s inner join orders_results.orders o on o.id = s.order_id;

INSERT INTO orders_results.subjects
(id, laboratory_id, subject_type, created_at, modified_at, deleted_at)
select s.id, cast(o.laboratory_id as uuid), 'PSEUDONYMIZED', s.created_at ,s.modified_at, s.deleted_at from 
orders_results.subjects_pseudonym s inner join orders_results.orders o on o.id = s.order_id;



INSERT INTO orders_results.subjects_donor_details
(id, subject_id, donor_id, date_of_birth, gender, blood_type, cde, kell, rhesusfactor)
SELECT uuid_generate_v4(), id, donor_id, date_of_birth, gender, blood_type, cde, kell, rhesusfactor
FROM orders_results.subjects_donor;

INSERT INTO orders_results.subjects_personal_details
(id, subject_id, first_name, last_name, date_of_birth, gender, address, postcode, city, country, phone_number_primary, phone_number_secondary)
SELECT uuid_generate_v4(), id, first_name, last_name, date_of_birth, gender, address, postcode, city, country, phone_number_primary, phone_number_secondary
FROM orders_results.subjects_personal;

INSERT INTO orders_results.subjects_pseudonym_details
(id, subject_id, pseudonym, date_of_birth, gender, customer_facility_id)
SELECT uuid_generate_v4(), s.id, s.pseudonym, s.date_of_birth, s.gender, o.customer_facility_id 
FROM orders_results.subjects_pseudonym s inner join orders_results.orders o on s.order_id = o.id;


-- +migrate Down

DELETE FROM orders_results.subjects_pseudonym_details;
DELETE FROM orders_results.subjects_personal_details;
DELETE FROM orders_results.subjects_donor_details;
DELETE FROM orders_results.subjects;