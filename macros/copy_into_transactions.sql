{% macro copy_into_transactions(
    target_table='raw.transactions',
    error_table='raw.error_table',
    audit_table='raw.transactions_audit',
    stage='@snap_sc.banking_stage',
    file_format='snap_sc.ff_p',
    pattern='.*transactions.*[.]parquet'
) %}

{% if execute %}

    {# 1. Load good rows, skip bad ones #}
    {% set load_sql %}
        COPY INTO {{ target_table }} (v, _source_file)
        FROM (SELECT $1, METADATA$FILENAME FROM '{{ stage }}')
        FILE_FORMAT = '{{ file_format }}'
        PATTERN = '{{ pattern }}'
        ON_ERROR = 'CONTINUE'
    {% endset %}
    {% set load_result = run_query(load_sql) %}

    {# 2. Log problem files (only if files were actually processed).
          Must run immediately after the COPY so LAST_QUERY_ID() points at it. #}
    {% if 'errors_seen' in load_result.column_names %}
        {% set log_errors_sql %}
            INSERT INTO {{ error_table }}
                (target_table, file_name, status, rows_parsed, rows_loaded,
                 errors_seen, first_error, first_error_line, first_error_col)
            SELECT
                '{{ target_table }}',
                "file", "status", "rows_parsed", "rows_loaded",
                "errors_seen", "first_error", "first_error_line",
                "first_error_column_name"
            FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
            WHERE "errors_seen" > 0
               OR "status" <> 'LOADED'
        {% endset %}
        {% do run_query(log_errors_sql) %}
    {% endif %}

    {# 3. Audit all loads from COPY_HISTORY #}
    {% set audit_sql %}
        MERGE INTO {{ audit_table }} a
        USING (
            SELECT
                FILE_NAME,
                STATUS,
                ROW_PARSED,
                ROW_COUNT,
                ERROR_COUNT,
                FIRST_ERROR_MESSAGE,
                LAST_LOAD_TIME
            FROM TABLE(
                {{ target.database }}.INFORMATION_SCHEMA.COPY_HISTORY(
                    TABLE_NAME => '{{ target_table }}',
                    START_TIME => DATEADD(DAY, -1, CURRENT_TIMESTAMP())
                )
            )
        ) h
        ON  a.file_name = h.FILE_NAME
        AND a.load_end_time = h.LAST_LOAD_TIME
        WHEN NOT MATCHED THEN
        INSERT (
            file_name,
            load_status,
            total_records,
            successful_records,
            failed_records,
            error_message,
            load_start_time,
            load_end_time
        )
        VALUES (
            h.FILE_NAME,
            h.STATUS,
            h.ROW_PARSED,
            h.ROW_COUNT,
            GREATEST(COALESCE(h.ROW_PARSED, 0) - COALESCE(h.ROW_COUNT, 0), 0),
            h.FIRST_ERROR_MESSAGE,
            NULL,
            h.LAST_LOAD_TIME
        )
    {% endset %}
    {% do run_query(audit_sql) %}

{% endif %}

{% endmacro %}