with payment as (
    select
        id as payment_id,
        orderid as order_id,
        status,
        amount / 100 as amount

    from
        {{ source('stripe','payment')}}
) 

select 
    order_id,
    status,
    count(distinct payment_id) as payment_cnt,
    sum(amount) as amount

from
    payment

group by
    order_id,
    status