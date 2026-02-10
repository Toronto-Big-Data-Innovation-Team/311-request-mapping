-- dump the data with cluster IDs
-- Easiest to just sort the spreadsheet they gave us by wonum
-- and append the group_names directly to that as a column
-- be sure to verify that wonums align
SELECT
    wonum,
    group_id
FROM data_analysis.m311_requests_raw AS requests
LEFT JOIN data_analysis.m311_kmeans_grouped_requests USING (wonum)
ORDER BY wonum;
