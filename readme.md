# Triaging 311 service requests related to snow/ice, Jan 2026

This repo contains work related to our efforts to quickly create maps of clusters of 311 service requests that could be given to staff who would need to go to the sites and investigate the requests.

## To reproduce this workflow

1. Get some fresh 311 service request data from someone with access to Maximo.
    - Make sure it includes coordinates. They are not lat/lon values. That's ok.
2. Import that data into a table, the structure of which is defined in [`inputs`](./inputs/requests_raw.sql).
    - Try `psql`'s `/copy` command from the EC2
    - You may need to make sure the fields provided to you align to the table.
    - Once the data is imported, run the second part of that query to add a field for geometries based on the coordinate values. 
3. Create the view [`requests_filtered`](./inputs/requests_filtered.sql).
    - At this stage, you should remove any service requests that shouldn't make it tot he final results
        - no geoms, things we were asked to remove, etc
4. Create the view [`kmeans_grouped_requests`](./clustering/kmeans_grouped_requests.sql)
    - This clusters the points and adds the group_id (combination of ownergroup and cluster_id within those ownergroups)
5. Create the view [`k_means_group_boundaries`](./clustering/kmeans_group_boundaries.sql)
    - This generates a bounding convex hull for each cluster which the atlas will focus on later
6. Using QGIS, open the file [`cluster-overview.qgs`](./cluster-overview.qgs)
    - You should see a simple citywide maps of the data points and clusters
    - This is just to verify because it's hard to get an overview in the final map with the atlas feature enabled.
7. Using QGIS, open the file [`atlas.qgs`](./atlas.qgs)
    - Data may not show up as you would expect.
    - Open the layout "8.5 x 11 Atlas"
8. In the layout window, under "Atlas", enable the atlas preview.
    - Tab between a few different pages and make sure things look OK
    - Make any tweaks to the layout or map styles, etc
9. Under the same "Atlas" menu, select "export as PDF"
    - Once you select a folder, this should export a separate PDF for each page, named like the example in [`/outputs`](./outputs)
