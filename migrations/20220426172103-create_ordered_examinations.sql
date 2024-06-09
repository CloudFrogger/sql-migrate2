
-- +migrate Up

CREATE TABLE IF NOT EXISTS orders_results.ordered_examinations (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    ordered_sample_id uuid NOT NULL REFERENCES orders_results.ordered_samples(id),
    examination_id uuid NOT NULL REFERENCES orders_results.examinations(id),
    deleted_at TIMESTAMP NULL
);

INSERT INTO orders_results.ordered_examinations (ordered_sample_id, examination_id) (SELECT id, examination_id FROM orders_results.ordered_samples);

ALTER TABLE orders_results.ordered_samples DROP COLUMN examination_id;

ALTER TABLE orders_results.ordered_examination_analytes ADD ordered_examination_id UUID NULL;

UPDATE orders_results.ordered_examination_analytes oea
    SET ordered_examination_id=(SELECT id FROM orders_results.ordered_examinations oe WHERE oe.ordered_sample_id=oea.ordered_sample_id AND oe.examination_id=oea.examination_id LIMIT 1);

ALTER TABLE orders_results.ordered_examination_analytes ALTER COLUMN ordered_examination_id SET NOT NULL;

ALTER TABLE orders_results.ordered_examination_analytes
    ADD CONSTRAINT ordered_examination_analytes_ordered_examination_fk
        FOREIGN KEY (ordered_examination_id) REFERENCES orders_results.ordered_examinations(id);

ALTER TABLE orders_results.ordered_examination_analytes DROP COLUMN ordered_sample_id;
ALTER TABLE orders_results.ordered_examination_analytes DROP COLUMN examination_id;

-- +migrate Down

ALTER TABLE orders_results.ordered_examination_analytes ADD ordered_sample_id UUID NULL;
ALTER TABLE orders_results.ordered_examination_analytes ADD examination_id UUID NULL;

UPDATE orders_results.ordered_examination_analytes oea
    SET (ordered_sample_id, examination_id)=(SELECT ordered_sample_id, examination_id FROM orders_results.ordered_examinations WHERE id=oea.ordered_examination_id);

ALTER TABLE orders_results.ordered_examination_analytes
    ADD CONSTRAINT ordered_examination_analytes_ordered_sample_fk
        FOREIGN KEY (ordered_sample_id) REFERENCES orders_results.ordered_samples(id);

ALTER TABLE orders_results.ordered_examination_analytes
    ADD CONSTRAINT ordered_examination_analytes_examination_fk
        FOREIGN KEY (examination_id) REFERENCES orders_results.examinations(id);

ALTER TABLE orders_results.ordered_examination_analytes ALTER COLUMN ordered_sample_id SET NOT NULL;
ALTER TABLE orders_results.ordered_examination_analytes ALTER COLUMN examination_id SET NOT NULL;

ALTER TABLE orders_results.ordered_examination_analytes DROP COLUMN ordered_examination_id;

ALTER TABLE orders_results.ordered_samples ADD examination_id UUID NULL;

UPDATE orders_results.ordered_samples os
    SET examination_id=(SELECT examination_id FROM orders_results.ordered_examinations WHERE ordered_sample_id=os.id LIMIT 1);

ALTER TABLE orders_results.ordered_samples
    ADD CONSTRAINT ordered_samples_examination_fk
        FOREIGN KEY (examination_id) REFERENCES orders_results.examinations(id);

ALTER TABLE orders_results.ordered_samples ALTER COLUMN examination_id SET NOT NULL;

DROP TABLE IF EXISTS orders_results.ordered_examinations;
