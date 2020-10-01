
-- creo schema
CREATE SCHEMA IF NOT EXISTS raw_data;

-- creo tabla para vincular sink en actividad de copiado desde storage

--versión 1
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

-- versión 2
CREATE TABLE raw_data.sample_table (
    dia character varying,
    hora character varying,
    lat double precision,
    long double precision,
    n_lineas integer
);