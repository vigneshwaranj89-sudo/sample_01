{{
    config(
        materialized='view'
    )
}}
SELECT
    v:customer_id::TEXT AS customer_id,
    v:customer_type::TEXT AS customer_type,
    v:first_name::TEXT AS first_name,
    v:last_name::TEXT AS last_name,
    v:business_name::TEXT AS business_name,
    v:date_of_birth::DATE AS date_of_birth,
    v:gender::TEXT AS gender,
    v:tax_id::TEXT AS tax_id,
    v:email::TEXT AS email,
    v:phone::TEXT AS phone,
    v:address_line1::TEXT AS address_line1,
    v:city::TEXT AS city,
    v:state::TEXT AS state,
    v:postal_code::TEXT AS postal_code,
    v:country::TEXT AS country,
    v:kyc_status::TEXT AS kyc_status,
    v:kyc_verified_date::DATE AS kyc_verified_date,
    v:risk_rating::TEXT AS risk_rating,
    v:segment::TEXT AS segment,
    v:home_branch_id::TEXT AS home_branch_id,
    v:onboarding_date::DATE AS onboarding_date,
    v:customer_status::TEXT AS customer_status,
    v:created_ts::TIMESTAMP_NTZ AS created_ts,
    v:last_updated_ts::TIMESTAMP_NTZ AS last_updated_ts
FROM {{ source('cust', 'customers_raw') }}