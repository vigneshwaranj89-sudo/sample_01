{% snapshot customer_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='last_updated_ts',
        check_cols= 'all'
    )
}}

SELECT
   *
FROM {{ ref('customer_dt') }}

{% endsnapshot %}