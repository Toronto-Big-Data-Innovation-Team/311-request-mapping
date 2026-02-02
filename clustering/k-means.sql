CREATE OR REPLACE VIEW nwessel.requests_filtered AS

SELECT *
FROM nwessel."311_requests"
WHERE
    failurecode != 'BUS STOP'
    AND NOT (
        failurecode = 'SIDEWALK'
        AND ownergroup != 'TSFITEY'
    );



CREATE OR REPLACE VIEW nwessel.kmeans_grouped_requests AS

WITH ownergroups AS (
    SELECT
        ownergroup,
        (COUNT(*) / 50::real)::int AS desired_k
    FROM nwessel.requests_filtered
    GROUP BY ownergroup
)

SELECT
    ROW_NUMBER() OVER () AS qgis_uid,
    clust.ownergroup || ' group ' || clust.cluster_id AS group_id,
    clust.*
FROM ownergroups
CROSS JOIN LATERAL (
    SELECT
        *,
        ST_ClusterKMeans(
            ST_Transform(wkb_geometry, 2952),
            ownergroups.desired_k,
            max_radius => 2500
        ) OVER (PARTITION BY ownergroup) AS cluster_id
    FROM nwessel.requests_filtered AS requests
    WHERE
        requests.ownergroup = ownergroups.ownergroup
        AND failurecode != 'BUS STOP'
) AS clust
ORDER BY ownergroup, cluster_id;

CREATE OR REPLACE VIEW nwessel.kmeans_group_boundaries AS

SELECT
    row_number() OVER () AS uid,
    group_id,
    ownergroup,
    cluster_id,
    ST_ConvexHull(ST_Collect(wkb_geometry)) AS bound_geom,
    COUNT(*) AS n
FROM nwessel.kmeans_grouped_requests
GROUP BY
    group_id,
    ownergroup,
    cluster_id
HAVING COUNT(*) > 2;

/*
WITH gs AS (
SELECT
    cluster_id,
    COUNT(*) AS n
FROM nwessel.kmeans_groups
GROUP BY cluster_id
) SELECT AVG(n) FROM gs
*/

/*
-- sent CSV outputs:
SELECT
    requests.*,
    cluster_id
FROM nwessel."311_requests" AS requests
JOIN nwessel.kmeans_groups USING (wonum)
*/