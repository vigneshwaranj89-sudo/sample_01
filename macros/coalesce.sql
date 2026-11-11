{% macro coal_mco(col) %}
    coalesce({{col}},'unknown')
{% endmacro %}