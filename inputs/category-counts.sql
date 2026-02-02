/*
For ordering / collapsing categories on the map legend
*/

SELECT
    description,
    location,
    failurecode,
    problemcode,
    COUNT(*)
FROM nwessel.requests_filtered
GROUP BY
    description,
    location,
    failurecode,
    problemcode
ORDER BY
    failurecode, 
    count DESC;
