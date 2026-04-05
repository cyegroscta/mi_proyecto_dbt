WITH pokemon AS (
    SELECT *
    FROM {{ ref('int_pokemon_enriched') }}
),

latest_rates AS (
    SELECT
        date,
        usd_rate,
        eur_rate,
        gbp_rate,
        jpy_rate
    FROM {{ ref('stg_exchange_rates') }}
    ORDER BY date DESC
    LIMIT 1   -- obtiene la fila más reciente
)

SELECT
    p.pokemon_id,
    p.pokemon_name,
    p.height,
    p.weight,
    p.base_experience,
    p.primary_type,
    p.num_types,
    p.weight_category,
    p.abilities,
    -- precio en USD (ejemplo: 10 * experiencia base)
    -- precio hipotético en USD (asumiendo 10 * experiencia)
    coalesce(10 * p.base_experience, 0) as usd_price,
    -- conversión a otras monedas
    coalesce(round(10 * p.base_experience * l.usd_rate, 2), 0) as eur_price,
    coalesce(round(10 * p.base_experience * l.gbp_rate, 2), 0) as gbp_price,
    coalesce(round(10 * p.base_experience * l.jpy_rate, 2), 0) as jpy_price,
    l.date as exchange_rate_date
FROM pokemon p
CROSS JOIN latest_rates l
