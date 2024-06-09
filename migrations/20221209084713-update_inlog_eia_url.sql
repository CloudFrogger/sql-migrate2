
-- +migrate Up
update orders_results.eia_mapping
set url = url || '/batch'

where service = 'INLOG interface'
and url not like '%/batch';

-- +migrate Down
update orders_results.eia_mapping
set url = replace(url,'/batch','')
where service = 'INLOG interface'
and url like '%/batch';