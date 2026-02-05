CREATE OR REPLACE VIEW nwessel.requests_filtered AS

SELECT *
FROM nwessel.requests_raw
WHERE
    -- specified that these be removed as they were being handled already
    -- or managed through a separate process
    geom IS NOT NULL
    AND failurecode != 'BUS STOP'
    AND description !~* 'plough damage'
    AND NOT (
        failurecode = 'SIDEWALK'
        AND ownergroup != 'TSFITEY'
    );
    