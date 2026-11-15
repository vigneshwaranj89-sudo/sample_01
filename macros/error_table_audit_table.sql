{% macro error_table_audit_table(
    schema='raw',
    database= 'snap_db'
) %}

{%set error_table%}

    create table if not exists error_table (
    target_table      varchar,
    file_name         varchar,
    status            varchar,
    rows_parsed       number,
    rows_loaded       number,
    errors_seen       number,
    first_error       varchar,
    first_error_line  number,
    first_error_col   varchar,
    last_load_time    timestamp_ntz,
    logged_at         timestamp_ntz default current_timestamp()
);

{%endset%}

{%do run_query (error_table) %}

{% endmacro %}