
-- +migrate Up
update orders_results.eia_mapping
set url = replace(url,'/int','')
where service = 'INLOG interface'
and url like '%/int%';

-- +migrate Down
update orders_results.eia_mapping
set url = replace(url,'/v1/result','/v1/int/result')
where service = 'INLOG interface'
and url like '%/v1/result%';
