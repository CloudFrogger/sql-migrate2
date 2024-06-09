
-- +migrate Up
CREATE INDEX IF NOT EXISTS idx_orders_customer_facility_id on orders_results.orders(customer_facility_id);
CREATE INDEX IF NOT EXISTS idx_orders_laboratory_id on orders_results.orders(laboratory_id);
CREATE INDEX IF NOT EXISTS idx_orders_deleted_at on orders_results.orders(deleted_at);

CREATE INDEX IF NOT EXISTS idx_ordered_samples_order_id on orders_results.ordered_samples(order_id);

CREATE INDEX IF NOT EXISTS idx_ordered_examinations_order_id on orders_results.ordered_examinations(order_id);

CREATE INDEX IF NOT EXISTS idx_ordered_examination_analytes_order_id on orders_results.ordered_examination_analytes(order_id);
CREATE INDEX IF NOT EXISTS idx_ordered_examination_analytes_sample_id on orders_results.ordered_examination_analytes(sample_id);

CREATE INDEX IF NOT EXISTS idx_orders_subject_id on orders_results.orders(subject_id);

CREATE INDEX IF NOT EXISTS idx_subjects_donor_details_subject_id on orders_results.subjects_donor_details(subject_id);
CREATE INDEX IF NOT EXISTS idx_subjects_personal_details_subject_id on orders_results.subjects_personal_details(subject_id);
CREATE INDEX IF NOT EXISTS idx_subjects_pseudonym_details_subject_id on orders_results.subjects_pseudonym_details(subject_id);

-- +migrate Down
DROP INDEX orders_results.idx_orders_customer_facility_id;
DROP INDEX orders_results.idx_orders_laboratory_id;
DROP INDEX orders_results.idx_orders_deleted_at;

DROP INDEX orders_results.idx_ordered_samples_order_id;

DROP INDEX orders_results.idx_ordered_examinations_order_id;

DROP INDEX orders_results.idx_ordered_examination_analytes_order_id;
DROP INDEX orders_results.idx_ordered_examination_analytes_sample_id;

DROP INDEX orders_results.idx_orders_subject_id;

DROP INDEX orders_results.idx_subjects_donor_details_subject_id;
DROP INDEX orders_results.idx_subjects_personal_details_subject_id;
DROP INDEX orders_results.idx_subjects_pseudonym_details_subject_id;