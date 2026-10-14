{{ config(materialized='table') }}

with source_data as (

   select *
   from {{ source('bigquery_source','orders') }}

)

select *
     ,ROUND(quantity * unit_price, 2) AS calculated_total
     ,CASE WHEN status = 'CANCELLED' THEN TRUE ELSE FALSE END AS is_cancelled
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
