
-- +migrate Up
CREATE TABLE IF NOT EXISTS orders_results.orders_filter (
    id uuid default uuid_generate_v4() PRIMARY KEY,
    order_id uuid not null,
    searchvalue varchar not null,
    searchtype varchar not null
);
CREATE INDEX searchvalue_order_id_orders_filter_IDX on orders_results.orders_filter (order_id, searchvalue);

INSERT INTO orders_results.orders_filter
	(order_id, searchvalue, searchtype)
	select order_id, first_name, 'first_name'  from orders_results.subjects_personal where first_name is not null;
	
INSERT INTO orders_results.orders_filter
	(order_id, searchvalue, searchtype)
	select order_id, last_name, 'last_name'  from orders_results.subjects_personal where last_name is not null;
	
INSERT INTO orders_results.orders_filter
	(order_id, searchvalue, searchtype)
	select order_id, donor_id, 'donor_id'  from orders_results.subjects_donor where donor_id is not null;
	
INSERT INTO orders_results.orders_filter
	(order_id, searchvalue, searchtype)
	select order_id, donation_id, 'donation_id'  from orders_results.subjects_donor where donation_id is not null;
	
INSERT INTO orders_results.orders_filter
	(order_id, searchvalue, searchtype)
	select order_id, pseudonym, 'pseudonym'  from orders_results.subjects_pseudonym where pseudonym is not null;

-- +migrate Down
DROP TABLE orders_results.orders_filter CASCADE;
