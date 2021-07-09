select
    orders.order_id,
    customers.customer_id,
    paid.amount

from
    {{ ref('stg_orders') }} as orders

left join
    {{ ref('dim_customers')}} as customers
        using(customer_id)

left join
    {{ ref('stg_payments')}} as paid
        using(order_id)