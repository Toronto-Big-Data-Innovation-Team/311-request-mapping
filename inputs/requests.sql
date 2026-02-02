/*
Structure of data as provided to us
Import from CSV with psql
but first make sure all the fields are the same and in the same order
*/

CREATE TABLE nwessel.requests_raw (
    wonum numeric,
    description text,
    location text,
    failurecode text,
    problemcode text,
    ownergroup text,
    reportdate text,
    targstartdate text,
    siteid text,
    -- provided as EPSG:102113
    latitudey numeric,
    longitudex numeric
);

-- run after to make geometries

ALTER TABLE nwessel.requests_raw ADD COLUMN geom geometry(POINT, 4326);
UPDATE nwessel.requests_raw SET geom = ST_Transform(
    ST_SetSRID(ST_MakePoint(longitudex, latitudey), 102113),
    4326
);
