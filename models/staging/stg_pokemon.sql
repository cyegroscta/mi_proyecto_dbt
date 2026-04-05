
-- Modelo de staging: limpieza básica y deduplicación por pokemon_id
WITH source AS (
    SELECT * FROM {{ source('raw', 'pokemon') }}
),
renamed AS (
    SELECT
        id AS pokemon_id,
        name AS pokemon_name,
        height,
        weight,
        base_experience,
        abilities,
        types,
        _airbyte_extracted_at AS loaded_at
    FROM source
),
deduplicated AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY pokemon_id
            ORDER BY loaded_at DESC
        ) AS rn
    FROM renamed
)
SELECT
    pokemon_id,
    pokemon_name,
    height,
    weight,
    base_experience,
    abilities,
    types,
    loaded_at
FROM deduplicated
WHERE rn = 1
