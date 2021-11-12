-- This SQL code should be executed last
DROP FUNCTION IF EXISTS getmvt(integer, integer, integer);
CREATE FUNCTION getmvt(zoom integer, x integer, y integer)
RETURNS TABLE(mvt bytea, key text) AS $$
SELECT mvt, md5(mvt) AS key FROM (SELECT GZIP(STRING_AGG(mvtl, '')) AS mvt FROM (
  SELECT COALESCE(ST_AsMVT(t, 'water', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, class, intermittent, brunnel FROM layer_water(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'waterway', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, name, name_en, name_de, NULLIF(tags->'name:en', '') AS "name:en", NULLIF(tags->'name:ru', '') AS "name:ru", NULLIF(tags->'name_int', '') AS "name_int", NULLIF(tags->'name:latin', '') AS "name:latin", NULLIF(tags->'name:nonlatin', '') AS "name:nonlatin", class, brunnel, intermittent FROM layer_waterway(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'landcover', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, class, subclass FROM layer_landcover(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'landuse', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, class FROM layer_landuse(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'park', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, class, name, name_en, name_de, NULLIF(tags->'name:en', '') AS "name:en", NULLIF(tags->'name:ru', '') AS "name:ru", NULLIF(tags->'name_int', '') AS "name_int", NULLIF(tags->'name:latin', '') AS "name:latin", NULLIF(tags->'name:nonlatin', '') AS "name:nonlatin", rank FROM layer_park(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom, 256)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'boundary', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, admin_level, disputed, disputed_name, claimed_by, maritime FROM layer_boundary(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'aeroway', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, ref, class FROM layer_aeroway(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'transportation', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 4, true) AS mvtgeometry, class, subclass, oneway, ramp, brunnel, service, layer, level, indoor, bicycle, foot, horse, mtb_scale, surface FROM layer_transportation(ST_Expand(ST_TileEnvelope(zoom, x, y), 39135.75848201026/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'water_name', 4096, 'mvtgeometry', 'osm_id'), '') as mvtl FROM (SELECT osm_id, ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 256, true) AS mvtgeometry, name, name_en, name_de, NULLIF(tags->'name:en', '') AS "name:en", NULLIF(tags->'name:ru', '') AS "name:ru", NULLIF(tags->'name_int', '') AS "name_int", NULLIF(tags->'name:latin', '') AS "name:latin", NULLIF(tags->'name:nonlatin', '') AS "name:nonlatin", class, intermittent FROM layer_water_name(ST_Expand(ST_TileEnvelope(zoom, x, y), 2504688.5428486564/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'transportation_name', 4096, 'mvtgeometry'), '') as mvtl FROM (SELECT ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 8, true) AS mvtgeometry, name, name_en, name_de, NULLIF(tags->'name:en', '') AS "name:en", NULLIF(tags->'name:ru', '') AS "name:ru", NULLIF(tags->'name_int', '') AS "name_int", NULLIF(tags->'name:latin', '') AS "name:latin", NULLIF(tags->'name:nonlatin', '') AS "name:nonlatin", ref, ref_length, network::text, class::text, subclass, layer, level, indoor FROM layer_transportation_name(ST_Expand(ST_TileEnvelope(zoom, x, y), 78271.51696402051/2^zoom), zoom)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'place', 4096, 'mvtgeometry', 'osm_id'), '') as mvtl FROM (SELECT osm_id, ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 256, true) AS mvtgeometry, name, name_en, name_de, NULLIF(tags->'name:en', '') AS "name:en", NULLIF(tags->'name:ru', '') AS "name:ru", NULLIF(tags->'name_int', '') AS "name_int", NULLIF(tags->'name:latin', '') AS "name:latin", NULLIF(tags->'name:nonlatin', '') AS "name:nonlatin", class, rank, capital, iso_a2 FROM layer_place(ST_Expand(ST_TileEnvelope(zoom, x, y), 2504688.5428486564/2^zoom), zoom, 256)) AS t
    UNION ALL
  SELECT COALESCE(ST_AsMVT(t, 'aerodrome_label', 4096, 'mvtgeometry', 'osm_id'), '') as mvtl FROM (SELECT osm_id, ST_AsMVTGeom(geometry, ST_TileEnvelope(zoom, x, y), 4096, 64, true) AS mvtgeometry, name, name_en, name_de, NULLIF(tags->'name:en', '') AS "name:en", NULLIF(tags->'name:ru', '') AS "name:ru", NULLIF(tags->'name_int', '') AS "name_int", NULLIF(tags->'name:latin', '') AS "name:latin", NULLIF(tags->'name:nonlatin', '') AS "name:nonlatin", class, iata, icao, ele, ele_ft FROM layer_aerodrome_label(ST_Expand(ST_TileEnvelope(zoom, x, y), 626172.1357121641/2^zoom), zoom)) AS t
) AS all_layers) AS mvt_data
;
$$ LANGUAGE SQL STABLE RETURNS NULL ON NULL INPUT;
