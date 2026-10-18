{{ config(materialized='table') }}

with base as (
    select *
    from {{ ref('customer_details') }}
)

,latest_order as (
    select customer_id
        ,order_date as last_order_date
        ,order_id as last_order_id
    from {{ ref('transformed_orders') }} 
    qualify row_number() over(partition by customer_id order by order_date desc)= 1
)

select distinct base.*
      ,latest_order.last_order_date
     ,latest_order.last_order_id
from base 
inner join latest_order on latest_order.customer_id = base.customer_id 
