CREATE OR REPLACE VIEW data_analysis.m311_kmeans_grouped_requests AS

WITH ownergroups AS (
    SELECT
        ownergroup,
        (COUNT(*) / 50::real)::int AS desired_k
    FROM data_analysis.m311_requests_filtered
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
            ST_Transform(geom, 2952),
            ownergroups.desired_k,
            max_radius => 2500
        ) OVER (PARTITION BY ownergroup) AS cluster_id
    FROM data_analysis.m311_requests_filtered AS requests
    WHERE
        requests.ownergroup = ownergroups.ownergroup
) AS clust
ORDER BY ownergroup, cluster_id;


ALTER VIEW data_analysis.m311_kmeans_grouped_requests OWNER TO analysis_admins;