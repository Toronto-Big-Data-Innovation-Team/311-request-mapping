CREATE OR REPLACE VIEW data_analysis.m311_kmeans_group_boundaries AS

SELECT
    row_number() OVER () AS uid,
    group_id,
    ownergroup,
    cluster_id,
    ST_ConvexHull(ST_Collect(geom)) AS bound_geom,
    COUNT(*) AS n
FROM data_analysis.m311_kmeans_grouped_requests
GROUP BY
    group_id,
    ownergroup,
    cluster_id
HAVING COUNT(*) > 2;

ALTER VIEW data_analysis.m311_kmeans_group_boundaries OWNER TO analysis_admins;