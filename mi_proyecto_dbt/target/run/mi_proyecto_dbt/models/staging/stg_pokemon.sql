
  
  create view "airbyte_curso"."main"."stg_pokemon__dbt_tmp" as (
    -- Modelo de staging: limpieza básica de datos crudos
WITH source AS (
SELECT * FROM "airbyte_curso"."main"."pokemon"
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
)
SELECT * FROM renamed
  );
