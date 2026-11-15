{% macro audit_table(
    schema='raw'
) %}

{% set create %}

CREATE TABLE raw.transactions_audit (
    audit_id NUMBER AUTOINCREMENT,
    file_name VARCHAR,
    load_status VARCHAR,
    total_records NUMBER,
    successful_records NUMBER,
    failed_records NUMBER,
    error_message VARCHAR,
    load_start_time TIMESTAMP_NTZ,
    load_end_time TIMESTAMP_NTZ,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
{%endset%}
    {% do run_query (create)%}
{% endmacro %}