{{ config( 
  materialized="view"
)}}

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

customer_orders as (
  select
    customer_id,

    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(order_id) as order_cnt

  from
    orders

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
    coalesce(customer_orders.order_cnt, 0) as order_cnt

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