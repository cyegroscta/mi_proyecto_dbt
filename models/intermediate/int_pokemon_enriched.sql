with pokemon as (
    select
        pokemon_id,
        pokemon_name,
        height,
        weight,
        base_experience,
        types,          -- es JSON
        abilities       -- también es JSON (si existe)
    from {{ ref('stg_pokemon') }}
),

enriched as (
    select
        *,
        -- Extraer primer tipo (índice 0)
        types->0->'type'->>'name' as primary_type,
        -- Extraer segundo tipo (índice 1), si existe
        types->1->'type'->>'name' as secondary_type,
        -- Contar elementos del array JSON
        json_array_length(types) as num_types,
        -- Categoría de peso
        case
            when weight < 50 then 'light'
            when weight between 50 and 200 then 'medium'
            else 'heavy'
        end as weight_category
    from pokemon
)

select * from enriched
