/*
For import of working table listing street segments that have already been
handled in one way or another
*/

CREATE TABLE nwessel.streets_completed (
    wonum text,
    district text,
    ward text,
    street text,
    from_intersection text,
    from_intersection_id text,
    to_intersection text,
    to_intersection_id text,
    sides_cleared text,
    side_cleared text,
    roadway text,
    sidewalk text,
    cycleway text
);

--ALTER TABLE nwessel.streets_completed ADD COLUMN uid serial PRIMARY KEY;
