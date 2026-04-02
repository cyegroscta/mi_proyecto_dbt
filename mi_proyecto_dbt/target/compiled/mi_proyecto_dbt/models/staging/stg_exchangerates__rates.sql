with source as (
    select *
    from "airbyte_curso"."main"."exchange_rates"
),

renamed as (
    select
        date,
        base_currency,
        rates->>'USD' as usd_rate,
        rates->>'EUR' as eur_rate,
        rates->>'GBP' as gbp_rate,
        rates->>'JPY' as jpy_rate,
        _airbyte_emitted_at as loaded_at
    from source
)

select * from renamed