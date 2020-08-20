---Esta es la estructura de tabla que estoy usando, con el tiempo hay campos que me quedaron obsoletos
---y ya no actualizo, te comento cuales son
CREATE TABLE telecom.actualizar_powerbi
(
    --id_2 integer NOT NULL DEFAULT nextval('telecom.actualizar_powerbi_id_2_seq'::regclass),
    id character varying COLLATE pg_catalog."default",
    id_cuadricula integer,
    --geom character varying 
    poblacion_caba integer,
    --semana_pre_cuarentena character varying 
    num_semana_precuarentena integer,
    cant_lineas_precuarentena integer,
    --semana_anterior character varying 
    num_semana_anterior integer,
    cant_lineas_semana_anterior integer,
    --semana_actual character varying 
    num_semana_actual integer,
    cant_lineas_actual integer,
    tipo_area character varying 
    area_interes character varying 
    --promedio character varying 
    actualizacion character varying 
    descripcion character varying 
    CONSTRAINT actualizar_powerbi_pkey PRIMARY KEY (id_2)
)


----Asi quedo el insert inicial ahora que uso una tabla consolidada con ids de zona de interes...DATE

INSERT INTO telecom.actualizar_powerbi(
	id_cuadricula, num_semana_actual, 
	cant_lineas_actual)
	
select fraccion, a.semana, 
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a ---- esta tabla es la que tiene todos los valores de dias y horas en las grillas
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (6,7,8)  and a.semana= 25 ---(dias habiles y en los horarios comerciales)
	and hora between '10:00' and '17:00' 
	group by fraccion,a.semana


