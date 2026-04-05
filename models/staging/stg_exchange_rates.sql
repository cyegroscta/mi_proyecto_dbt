with source as (
    select *
    from {{ source('raw', 'exchange_rates') }}
),

renamed as (
    select
        date,
        base,
        (rates->>'USD')::DOUBLE as usd_rate,
        (rates->>'EUR')::DOUBLE as eur_rate,
        (rates->>'GBP')::DOUBLE as gbp_rate,
        (rates->>'JPY')::DOUBLE as jpy_rate,
        _airbyte_extracted_at as loaded_at
       
    from source
)

select * from renamed
