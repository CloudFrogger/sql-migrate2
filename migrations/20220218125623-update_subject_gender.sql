
-- +migrate Up
update orders_results.subjects_donor
set gender = 'M'
where lower(gender) in ('male', 'm');

update orders_results.subjects_personal
set gender = 'M'
where lower(gender) in ('male', 'm');

update orders_results.subjects_pseudonym
set gender = 'M'
where lower(gender) in ('male', 'm');


update orders_results.subjects_donor
set gender = 'W'
where lower(gender) in ('female', 'w');

update orders_results.subjects_personal
set gender = 'W'
where lower(gender) in ('female', 'w');

update orders_results.subjects_pseudonym
set gender = 'W'
where lower(gender) in ('female', 'w');


update orders_results.subjects_donor
set gender = 'U'
where lower(gender) in ('undefined', 'u');

update orders_results.subjects_personal
set gender = 'U'
where lower(gender) in ('undefined', 'u');

update orders_results.subjects_pseudonym
set gender = 'U'
where lower(gender) in ('undefined', 'u');
-- +migrate Down
