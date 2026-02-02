CREATE OR REPLACE VIEW nwessel.requests_filtered AS

SELECT *
FROM nwessel.requests_raw
WHERE
    -- specified that these be removed as they were being handled already
    -- or managed through a separate process
    failurecode != 'BUS STOP'
    AND NOT (
        failurecode = 'SIDEWALK'
        AND ownergroup != 'TSFITEY'
    );
