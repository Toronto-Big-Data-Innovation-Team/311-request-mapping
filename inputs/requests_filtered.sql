CREATE OR REPLACE VIEW data_analysis.m311_requests_filtered AS

SELECT *
FROM data_analysis.m311_requests_raw
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
    
ALTER VIEW data_analysis.m311_requests_filtered OWNER TO analysis_admins;