
-- +migrate Up
UPDATE orders_results.orders
SET sample_date_date = sample_date_temp::date, 
sample_date_time = 
CASE 
	WHEN sample_date_temp::time = '00:00:00' THEN NULL
	ELSE sample_date_temp::time
END;

-- +migrate Down
UPDATE orders_results.orders
SET sample_date_temp =
CASE 
	WHEN sample_date_time IS NULL THEN (cast(sample_date_date as varchar) || ' 00:00:00')::timestamp
	ELSE (cast(sample_date_date as varchar) || ' ' || cast(sample_date_time as varchar))::timestamp
END;