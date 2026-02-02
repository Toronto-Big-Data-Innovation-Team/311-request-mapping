-- dump the data with cluster IDs
SELECT
    requests.*,
    cluster_id,
    group_id
FROM nwessel.requests_raw AS requests
JOIN nwessel.kmeans_groups USING (wonum)
