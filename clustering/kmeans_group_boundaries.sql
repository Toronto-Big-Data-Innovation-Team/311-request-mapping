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
