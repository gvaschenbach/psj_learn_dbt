{{ config( 
  materialized="table"
)}}

with customers as (
    select
        id as customer_id,
        first_name,
        last_name

    from 
        psj_learn_dbt.jaffle_shop.customers
)

select
    *
from
    customers