
-- +migrate Up
-------------------------------------------- donor duplication handlINg --------------------------------------------
--ASsign subject ids to duplicated donor orders
UPDATE orders_results.orders AS o 
SET subject_id = 
(
SELECT subject_id FROM 
(SELECT subject_id, donor_id,
         ROW_NUMBER() OVER( PARTITION BY donor_id
        ORDER BY id ) AS row_num
        FROM orders_results.subjects_donor_details
        WHERE donor_id =
        (
        SELECT donor_id FROM orders_results.subjects_donor_details dt WHERE o.subject_id = dt.subject_id 

        )
 ) AS t 

 WHERE t.row_num =1
)

WHERE subject_id IN (
SELECT subject_id FROM 
(SELECT subject_id, donor_id,
         ROW_NUMBER() OVER( PARTITION BY donor_id
        ORDER BY id ) AS row_num
        FROM orders_results.subjects_donor_details
        WHERE donor_id =
        (
        SELECT donor_id FROM orders_results.subjects_donor_details dt WHERE o.subject_id = dt.subject_id 

        )
 ) AS t 

 WHERE t.row_num > 1
);

------------------mark unused subjects AS deleted
UPDATE orders_results.subjects
SET deleted_at = NOW() 
WHERE id NOT IN (
SELECT subject_id FROM orders_results.orders 
);

-- +migrate Down
