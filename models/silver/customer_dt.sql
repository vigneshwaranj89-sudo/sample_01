{{
    config(
        materialized='table',
        schema='silver'
    )
}}
select customer_id,  
customer_type,
coalesce(first_name||' '||last_name,'unknown')  as full_name, 
coalesce(to_varchar(date_of_birth),'unknown') as date_of_birth,
Coalesce(to_varchar(datediff('year',date_of_birth,current_date())),'unknown') as Age,
CASE 
    when lower(gender)='m' then 'MALE'
    when lower(gender)='f' then 'FEMALE'
    ELSE 'unknown'
END as gender,
coalesce(business_name,'unknown') as business_name,
coalesce(tax_id,'unknown') as tax_id,
coalesce(lower(email),'unknown') as email,
coalesce(LOWER(SPLIT_PART(email, '@', 2)),'unknown') AS email_domain,
coalesce(phone,'unknown') as phone,
{{coal_mco('address_line1')}} as address_line1,
{{coal_mco('city')}} as city,
{{coal_mco('state')}} as state,
{{coal_mco('postal_code')}} as postal_code,
{{coal_mco('country')}} as country,
{{coal_mco('kyc_status')}} as kyc_status,
{{coal_mco('to_varchar(kyc_verified_date)')}} as kyc_verified_date,
{{coal_mco('risk_rating')}} as risk_rating,
{{coal_mco('segment')}} as segment,
{{coal_mco('home_branch_id')}} as home_branch_id,
{{coal_mco('to_varchar(onboarding_date)')}} as onboarding_date,
{{coal_mco('customer_status')}} as customer_status,
{{coal_mco('created_ts')}} as created_ts,
{{coal_mco('last_updated_ts')}} as last_updated_ts,
{{coal_mco('change_type')}}       as change_type,
{{coal_mco('to_varchar(change_ts)')}}     as change_ts,       -- cast it the same way you cast last_updated_ts
{{coal_mco('changed_columns')}}      as changed_columns,
{{coal_mco('batch_id')}}            as batch_id,
row_number() over(partition by customer_id order by last_updated_ts desc) as rn

from {{ ref('customers') }}
qualify rn=1