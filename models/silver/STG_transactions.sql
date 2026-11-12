{{
    config(
        materialized='table',
        schema='silver'
    )
}}

select 

v:txn_id::TEXT AS txn_id,
v:account_id::NUMBER(38, 0) AS account_id,
v:txn_ts::TIMESTAMP_NTZ AS txn_ts,
v:value_date::DATE AS value_date,
v:txn_type::TEXT AS txn_type,
v:channel::TEXT AS channel,
v:direction::TEXT AS direction,
v:amount::NUMBER(18, 2) AS amount,
v:currency::TEXT AS currency,
v:balance_after::NUMBER(18, 2) AS balance_after,
v:description::TEXT AS description,
v:counterparty_account::TEXT AS counterparty_account,
v:merchant_category_code::NUMBER(38, 0) AS merchant_category_code,
v:status::TEXT AS status

from {{ source('cust', 'transactions') }}