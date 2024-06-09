-- +migrate Up
create table orders_results.gender_definition
(
    gender      varchar     not null primary key,
    description varchar(50) not null
);

insert into orders_results.gender_definition (gender, description)
values ('M', 'Male');
insert into orders_results.gender_definition (gender, description)
values ('F', 'Female');
insert into orders_results.gender_definition (gender, description)
values ('U', 'Undefined');

update orders_results.subjects_personal
set gender = 'U'
where gender not in ('M', 'F', 'U');

alter table orders_results.subjects_personal
    add constraint fk_gender foreign key (gender) references orders_results.gender_definition (gender);
-- +migrate Down
