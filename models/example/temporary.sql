{{ config(materialized='view') }}

SELECT *
FROM {{ ref('customer_dt') }}
WHERE customer_id IN (
    SELECT v:customer_id::VARCHAR
    FROM {{ source('cust', 'customers_raw') }}
    WHERE _source_file = 'customers.parquet'
)
