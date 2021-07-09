with whale as (
  select
    *
  from
    {{ ref('dim_customers')}}

  where
    order_cnt > 3
)

select
    *
from
    whale