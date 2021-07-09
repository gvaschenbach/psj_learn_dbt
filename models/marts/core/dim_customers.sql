with customers as (
    select
        *
    
    from 
      {{ ref('stg_customers') }}
),

orders as (
    select
        *

    from
      {{ ref('stg_orders') }}
),

paid as (
    select
        *
    from
        {{ ref('stg_payments') }}
),

order_payments as (
  select
    order_id,
    sum(case when status = 'success' then amount end) as amount

  from
    paid

  group by
    order_id
),

customer_orders as (
  select
    customer_id,

    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(order_id) as order_cnt,
    sum(amount) as lifetime_value_amt

  from
    orders

  left join
    order_payments
      using(order_id)

  group by
    customer_id
),

final as (
  select
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order_date,
    customer_orders.last_order_date,
    coalesce(customer_orders.order_cnt, 0) as order_cnt,
    customer_orders.lifetime_value_amt

  from
    customers

  left join
    customer_orders 
      using(customer_id)
)

select
  *
from
  final