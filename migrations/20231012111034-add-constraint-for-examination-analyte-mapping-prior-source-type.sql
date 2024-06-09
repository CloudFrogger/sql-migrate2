
-- +migrate Up
CREATE TABLE orders_results.examination_analyte_mapping_prior_source_types(
  type varchar NOT NULL,
  CONSTRAINT pk_examination_analyte_mapping_prior_source_types PRIMARY KEY (type)
);

INSERT INTO orders_results.examination_analyte_mapping_prior_source_types
VALUES ('BLOODTYPE'),('RHESUS'),('KELL'),('CDE'),('CDE_TO_CE'),('DONATIONTYPE'),('SUBJECT_MOST_RECENT');

ALTER TABLE orders_results.examination_analyte_mapping
RENAME COLUMN prior_source_type TO prior_source_type_old;

ALTER TABLE orders_results.examination_analyte_mapping
ADD COLUMN prior_source_type varchar DEFAULT(NULL);

ALTER TABLE orders_results.examination_analyte_mapping
ADD CONSTRAINT fk_examination_analyte_mapping_prior_source_type FOREIGN KEY (prior_source_type) REFERENCES orders_results.examination_analyte_mapping_prior_source_types(type);

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type = 'BLOODTYPE'
WHERE prior_source_type_old = 1;

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type = 'CDE'
WHERE prior_source_type_old = 2;

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type = 'RHESUS'
WHERE prior_source_type_old = 3;

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type = 'KELL'
WHERE prior_source_type_old = 4;

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type = 'DONATIONTYPE'
WHERE prior_source_type_old = 5;

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type = 'SUBJECT_MOST_RECENT'
WHERE prior_source_type_old = 6;

ALTER TABLE orders_results.examination_analyte_mapping
DROP COLUMN prior_source_type_old;

-- +migrate Down
ALTER TABLE orders_results.examination_analyte_mapping
ADD COLUMN prior_source_type_old int DEFAULT(NULL);

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type_old = 1
WHERE prior_source_type = 'BLOODTYPE';

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type_old = 2
WHERE prior_source_type = 'CDE'
OR prior_source_type = 'CDE_TO_CE';

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type_old = 3
WHERE prior_source_type = 'RHESUS';

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type_old = 4
WHERE prior_source_type = 'KELL';

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type_old = 5
WHERE prior_source_type = 'DONATIONTYPE';

UPDATE orders_results.examination_analyte_mapping
SET prior_source_type_old = 6
WHERE prior_source_type = 'SUBJECT_MOST_RECENT';

ALTER TABLE orders_results.examination_analyte_mapping
DROP COLUMN prior_source_type;

ALTER TABLE orders_results.examination_analyte_mapping
RENAME COLUMN prior_source_type_old TO prior_source_type;

DROP TABLE orders_results.examination_analyte_mapping_prior_source_types;
