-- +migrate Up
CREATE UNIQUE INDEX subject_donor_order_id ON orders_results.subjects_donor (order_id);
CREATE UNIQUE INDEX subject_pseudonym_order_id ON orders_results.subjects_pseudonym (order_id);
CREATE UNIQUE INDEX subject_personal_order_id ON orders_results.subjects_personal (order_id);

CREATE INDEX ordered_samples_order_id ON orders_results.ordered_samples (order_id);

-- +migrate Down
DROP INDEX orders_results.subject_donor_order_id;
DROP INDEX orders_results.subject_pseudonym_order_id;
DROP INDEX orders_results.subject_personal_order_id;
DROP INDEX orders_results.ordered_samples_order_id;