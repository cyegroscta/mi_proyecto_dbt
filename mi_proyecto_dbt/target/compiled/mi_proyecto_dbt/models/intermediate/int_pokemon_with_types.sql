-- Extraer tipos del JSON y unir con datos base
WITH pokemon AS (
SELECT * FROM "airbyte_curso"."main"."stg_pokemon"
),
pokemon_types AS (
SELECT
pokemon_id,
pokemon_name,
height,
weight,
base_experience,
types->0->'type'->>'name' AS type_primary,
types->1->'type'->>'name' AS type_secondary
FROM pokemon
)
SELECT * FROM pokemon_types