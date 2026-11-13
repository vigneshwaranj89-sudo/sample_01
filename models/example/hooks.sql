{{
    config(
        materialized='table',
        schema='snap_sc',
        query_tag='DBT_VIG',
        pre_hook =['use warehouse compute_wh','use schema raw'],
        post_hook =['use warehouse dbt_wh']
    )
}}

select 'vignesh' as name,
'data engineer' as role