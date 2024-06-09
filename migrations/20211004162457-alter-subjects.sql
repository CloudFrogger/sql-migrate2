
-- +migrate Up
alter table orders_results.subjects_donor ALTER COLUMN date_of_birth DROP NOT NULL;
alter table orders_results.subjects_personal ALTER COLUMN date_of_birth DROP NOT NULL;


-- +migrate Down
update orders_results.subjects_donor set date_of_birth = TIMESTAMP '1900-01-01' where date_of_birth is null;
update orders_results.subjects_personal set date_of_birth = TIMESTAMP '1900-01-01' where date_of_birth is null;

alter table orders_results.subjects_donor ALTER COLUMN date_of_birth SET NOT NULL;
alter table orders_results.subjects_personal ALTER COLUMN date_of_birth SET NOT NULL;