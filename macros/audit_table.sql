{% macro audit_table(
    schema='raw'
) %}

{% set create %}

create table if not exists load_audit (
    run_id          varchar,
    target_table    varchar,
    file_name       varchar,
    status          varchar,
    rows_loaded     number,
    errors_seen     number,
    load_ts         timestamp_ntz default current_timestamp()
);

{%endset%}
    {% do run_query (create)%}
{% endmacro %}