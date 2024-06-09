
-- +migrate Up
create index orders_blood_donor_details_order_id on orders_results.orders_blood_donor_details(order_id);
create index orders_created_at on orders_results.orders(created_at);
create index ordered_examinations_ordered_sample_id on orders_results.ordered_examinations(ordered_sample_id);

create extension if not exists "pg_trgm" schema public;

CREATE INDEX gin_ordered_samples_sample_code on orders_results.ordered_samples using gin (sample_code gin_trgm_ops);
CREATE INDEX gin_subjects_donor_details_donor_id ON orders_results.subjects_donor_details USING gin (donor_id gin_trgm_ops);
CREATE INDEX gin_subjects_personal_details ON orders_results.subjects_personal_details USING gin (first_name gin_trgm_ops, last_name gin_trgm_ops);
CREATE INDEX gin_subjects_pseudonym_details_pseudonym ON orders_results.subjects_pseudonym_details USING gin (pseudonym gin_trgm_ops);

-- +migrate Down
drop index gin_ordered_samples_sample_code;
drop index gin_subjects_donor_details_donor_id;
drop index gin_subjects_personal_details;
drop index gin_subjects_pseudonym_details_pseudonym;

drop extension "pg_trgm";

drop index orders_blood_donor_details_order_id;
drop index orders_created_at;
drop index ordered_examinations_ordered_sample_id;
