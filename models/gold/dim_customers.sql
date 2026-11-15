{{
    config(
        materialized='incremental',
        schema ='gold',
        unique_key='customer_id',
        incremental_strategy='merge',
        on_schema_change='append_new_columns'
    )
}}

select *,{{dbt_utils.generate_surrogate_key(['customer_id'])}} as customer_key from {{ ref('customer_dt') }}

{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where last_updated_ts >= (SELECT DATEADD(
                DAY, -1,
                COALESCE(
                    MAX(last_updated_ts),
                    '1900-01-01'::TIMESTAMP_NTZ
                )
            )
            FROM {{ this }}
        )
{% endif %}