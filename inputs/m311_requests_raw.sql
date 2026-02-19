/*
Structure of data as provided to us
Import from CSV with psql
but first make sure all the fields are the same and in the same order
*/

CREATE TABLE data_analysis.m311_requests_raw (
    wonum numeric,
    description text,
    location text,
    failurecode text,
    problemcode text,
    status text,
    supervisor text,
    ownergroup text,
    worktype text,
    wopriority text,
    reportdate text,
    targstartdate text,
    siteid text,
    statusdate text,
    assignedownergroup text,
    -- provided as EPSG:102113
    latitudey numeric,
    longitudex numeric,
    cotward text
);

ALTER TABLE data_analysis.m311_requests_raw OWNER TO analysis_admins; -- would like this to be its own distinct role


-- run after to make geometries

ALTER TABLE data_analysis.m311_requests_raw ADD COLUMN geom geometry(POINT, 4326);
UPDATE data_analysis.m311_requests_raw SET geom = ST_Transform(
    ST_SetSRID(ST_MakePoint(longitudex, latitudey), 102113),
    4326
);
