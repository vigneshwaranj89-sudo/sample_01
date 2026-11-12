{% test space_validate(model,column_name) %}

select * from {{model}}
where {{column_name}} <> trim({{column_name}})

{%endtest%}