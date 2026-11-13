{{
    config(
        materialized='incremental',
        schema ='gold',
        transient='false',
        unique_key='txn_id',
       incremental_strategy ='merge',
       on_schema_change='append_new_columns'
       
    )
}}

select {{dbt_utils.generate_surrogate_key(['txn_id'])}} as txn_key,
txn_id,
account_id,
txn_ts,
value_date,
amount,
currency,
balance_after
 from {{ref('STG_transactions')}}

 {% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where txn_ts >= (select DATEADD('DAY',-1, COALESCE(
                    MAX(txn_ts),
                    '1900-01-01'::TIMESTAMP_NTZ
                )) from {{ this }}) 
 {% endif %}