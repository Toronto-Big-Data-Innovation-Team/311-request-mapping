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
4. Create the view [`k_means_group_boundaries`](./clustering/kmeans_group_boundaries.sql)
    - This generates a bounding convex hull for each cluster which the atlas will focus on later
5. 