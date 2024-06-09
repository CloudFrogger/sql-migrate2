
-- +migrate Up

CREATE TABLE IF NOT EXISTS orders_results.ordered_examination_analytes (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    ordered_sample_id uuid not null references orders_results.ordered_samples (id),
    examination_id uuid not null references orders_results.examinations (id),
    analyte_id varchar not null,
    workitem_id uuid null,
    transfer_data_to_cerberus timestamp null,
    created_at timestamp not null default (now() at time zone 'utc'),
    modified_at timestamp,
    modified_by varchar,
    deleted_at timestamp null
    );

-- +migrate Down

DROP TABLE orders_results.ordered_examination_analytes CASCADE;
