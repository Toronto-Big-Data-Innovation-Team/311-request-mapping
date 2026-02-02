/*
geocoding function takes a while (~3-4mins currently), so this is materialized
*/

CREATE MATERIALIZED VIEW nwessel.geocoded_streets_completed AS

WITH routed AS (
    SELECT
        ROW_NUMBER() OVER() AS qgis_uid,
        *
    FROM nwessel.streets_completed
    CROSS JOIN LATERAL (
        SELECT *
        FROM gis_core.get_centreline_btwn_intersections(
            from_intersection_id::int,
            to_intersection_id::int
        )
    ) AS geocode
    WHERE
        -- ID exists and is an int
        from_intersection_id ~ '^\d+$'
        AND to_intersection_id ~ '^\d+$'
),

name_ids AS (
    SELECT
        qgis_uid,
        street,
        unnest(links)::int AS centreline_id
    FROM routed
),

ids_with_matched_names AS (
    -- only keep results that have that given street name
    SELECT
        qgis_uid
    FROM name_ids
    JOIN gis_core.centreline_latest USING (centreline_id)
    GROUP BY qgis_uid
    HAVING EVERY(street = linear_name_full)
)

SELECT *
FROM ids_with_matched_names
JOIN routed USING (qgis_uid);
