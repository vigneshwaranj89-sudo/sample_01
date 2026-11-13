{{
    config(
         materialized='table',
        schema ='gold',
        transient='false'
    )
}}

select {{dbt_utils.generate_surrogate_key(['txn_type','channel','direction'])}} as txn_type_key, 
txn_type,
channel,
direction,
description,
counterparty_account,
merchant_category_code,
status
from {{ ref('STG_transactions')}}