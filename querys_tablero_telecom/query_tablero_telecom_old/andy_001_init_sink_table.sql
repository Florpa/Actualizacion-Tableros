
-- creo schema
CREATE SCHEMA IF NOT EXISTS raw_data;

-- creo tabla para vincular sink en actividad de copiado desde storage

-- raw_data DEV
CREATE TABLE raw_data.sample_table (
    dia character varying,
    hora character varying,
    lat double precision,
    long double precision,
    n_lineas integer
);

-- raw_data PROD
CREATE TABLE raw_data.new_data (
    dia character varying,
    hora character varying,
    lat double precision,
    long double precision,
    n_lineas integer
);
-- corrida pipeline 2020-08-18
-- TRAFICO_Caba_17ago.txt
-- raw_data
-- new_data

-- staged_data sample
CREATE TABLE staged_data.sample_table (
    dia date,
    hora character varying,
    geom_4326 geometry,
    geom_5347 geometry,
    n_lineas integer
);

-- creo tabla para hacer primer increment de antenas
CREATE TABLE staged_data.grilla_antenas_sample_table (
    id_grilla integer,
    dia,
    hora,
    moviles integer,
    semana integer
);
