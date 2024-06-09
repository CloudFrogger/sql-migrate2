
-- +migrate Up
ALTER TABLE orders_results.ordered_examinations
    ADD COLUMN order_id uuid not null default('00000000-0000-0000-0000-000000000000');

UPDATE orders_results.ordered_examinations oe
SET order_id = os.order_id
FROM orders_results.ordered_samples os
WHERE os.id = oe.ordered_sample_id;

ALTER TABLE orders_results.ordered_examinations
    ADD CONSTRAINT fk_order_examination_order_id FOREIGN KEY (order_id) references orders_results.orders(id);

CREATE TABLE orders_results.order_examination_sample_mapping(
    id uuid not null default(uuid_generate_v4()),
    order_examination_id uuid not null,
    sample_id uuid not null,
    sample_index int not null,
    created_at timestamp not null default(timezone('utc',now())),
    deleted_at timestamp,
    constraint pk_order_examination_sample_mapping primary key (id),
    constraint fk_order_examination_sample_mapping_order_examination_id foreign key (order_examination_id) references orders_results.ordered_examinations,
    constraint fk_order_examination_sample_mapping_sample_id foreign key (sample_id) references orders_results.ordered_samples(id)
);

INSERT INTO orders_results.order_examination_sample_mapping(order_examination_id, sample_id, sample_index)
SELECT oe.id, os.id, os.mapped_material
FROM orders_results.orders o
INNER JOIN orders_results.ordered_samples os ON os.order_id = o.id
INNER JOIN orders_results.ordered_examinations oe ON oe.ordered_sample_id = os.id;

ALTER TABLE orders_results.ordered_examination_analytes
    ADD COLUMN order_id uuid not null default('00000000-0000-0000-0000-000000000000');

ALTER TABLE orders_results.ordered_examination_analytes
    ADD COLUMN sample_id uuid not null default('00000000-0000-0000-0000-000000000000');

ALTER TABLE orders_results.ordered_examination_analytes
    ADD COLUMN order_examination_sample_mapping_id uuid not null default('00000000-0000-0000-0000-000000000000');

UPDATE orders_results.ordered_examination_analytes oea
SET order_id = oe.order_id, sample_id = oe.ordered_sample_id, order_examination_sample_mapping_id = oesm.id
    FROM orders_results.ordered_examinations oe
INNER JOIN orders_results.ordered_samples os ON os.id = oe.ordered_sample_id
    INNER JOIN orders_results.order_examination_sample_mapping oesm ON oesm.order_examination_id = oe.id AND oesm.sample_id = os.id
WHERE oea.ordered_examination_id = oe.id;

ALTER TABLE orders_results.ordered_examination_analytes
    ADD CONSTRAINT fk_ordered_examination_analytes_order_id foreign key (order_id) references orders_results.orders(id);

ALTER TABLE orders_results.ordered_examination_analytes
    ADD CONSTRAINT fk_ordered_examination_analytes_sample_id foreign key (sample_id) references orders_results.ordered_samples(id);

ALTER TABLE orders_results.ordered_examination_analytes
    ADD CONSTRAINT fk_ordered_examination_analytes_sample_mapping_id foreign key (order_examination_sample_mapping_id) references orders_results.order_examination_sample_mapping(id);

ALTER TABLE orders_results.ordered_examinations
DROP COLUMN ordered_sample_id;

ALTER TABLE orders_results.ordered_samples
DROP COLUMN mapped_material;

-- +migrate Down


