
-- creo schema
CREATE SCHEMA IF NOT EXISTS raw_data;

-- creo tabla para vincular sink en actividad de copiado desde storage
CREATE TABLE raw_data.sample_table (
    id integer,
    dia character varying ,
    time character varying ,
    uli_sitiorm_latitud double precision,
    uli_sitiorm_longitud double precision,
    lineas integer,
    cdl_provincia character varying,
    cdl_localidad character varying,
    sitiorm_agrupador_zona_de_servic character varying,
    barrio character varying,
    hora character varying,
    day character varying ,
    id_2 integer
);

/*

Columnas que probablemente haya que corregir:

- uli_sitiorm_latitud, uli_sitiorm_longitud pasan a latitude, longitude
- eliminar las columnas de geo (cdl_provincia, cdl_localidad, sitiorm_agrupador_zona_de_servic, barrio) si se recuperan desde lat-long
- eliminar las columnas hora, day, dia si ya están en time
- corregir y que haya un solo ID

/*