
-- +migrate Up
update orders_results.orders set status = 'DELETED', deleted_at = timezone('utc', now())
where id in (
    select os.order_id from orders_results.ordered_examination_analytes oea
    inner join orders_results.ordered_examinations oe on oe.id = oea.ordered_examination_id
    inner join orders_results.ordered_samples os on os.id = oe.ordered_sample_id
    group by os.order_id
    having count(*) = count(*) filter (where oea.status = 'cancelled')
);

-- +migrate Down
