-- +migrate Up

create schema if not exists orders_results;

create table if not exists orders_results.examinations (
    id uuid default uuid_generate_v4(),
    code varchar(32) not null,
    description varchar(128),
    laboratory_id uuid not null,
	material1_id uuid not null,
	material2_id uuid not null,
	material3_Id uuid not null,
    created_at timestamp not null default (now() at time zone 'utc'),
    modified_at timestamp,
    modified_by varchar,
    deleted boolean default false,
	constraint pk_examinations primary key (id)
);

create table if not exists orders_results.examination_analyte_mapping (
    id uuid default uuid_generate_v4(),
    material_id uuid not null,
    analyte_id uuid not null,
    examination_id uuid not null,
    created_at timestamp not null default (now() at time zone 'utc'),
    modified_at timestamp,
    modified_by varchar,
    deleted boolean default false,
    constraint pk_examination_analyte_mapping primary key (id),
    constraint fk_examinations__id foreign key (examination_id) REFERENCES orders_results.examinations (id)
);

create table if not exists orders_results.logs (
    id uuid default uuid_generate_v4(),
    created_at timestamp not null default (now() at time zone 'utc'),
    "level" varchar(32),
    message varchar(2048),
    constraint pk_logs primary key (id)
);

-- +migrate Down

drop table if exists orders_results.examination_analyte_mapping;
drop table if exists orders_results.examinations;
drop table if exists orders_results.logs;
drop schema if exists orders_results CASCADE;
