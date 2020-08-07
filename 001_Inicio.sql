--- Luego de subir la tabla al postgres, hay que generarle la columna de geom a la nueva tabla
--- esta columna sera usada luego
alter table telecom.dispositivos_fechaxxx add column geom geometry 

---- Chequeo cual es el ultimo dia que tengo en la tabla donde hare un insert con los dias faltantes
---- Puede haber saltos entre los dias, esto lo chequeo para insertar todos los dias que faltan..

select distinct (day::date) 
    from telecom.dispositivos_fechaxxx
    where day::date >'2020-07-20'order by day 

select max (day::date) 
    from telecom.mitablamadre

--- Una vez que corrobore que dias me falta/ voy a insertar creo una tabla
--- se podria hacer un insert directamente? si, 
--- pero hay que cambiar la estructura de la tabla para que coincidan, 
--  yo prefiero hacer una tabla intermedia que luego dropeare

create table registros_insert as

SELECT id_2 as registro,id, uli_sitiorm_latitud as lat, uli_sitiorm_longitud as 
        long,(ST_SetSRID(ST_MakePoint(uli_sitiorm_longitud , uli_sitiorm_latitud),4326))as geom,
        cdl_provincia, cdl_localidad, sitiorm_agrupador_zona_de_servic as zona_serv, 
        barrio,day::date,hora,lineas as cant_lineas
	FROM telecom.dispositivos_fechaxx 
    where day::date >'fecha ultimo dia insertado' order by day 

--- Chequeo que dias voy a insertar...				 
select distinct (day) 
from  registros_insert	order by day	 
--- Inserto los registros que no estaban en mi tablamadre
				 
INSERT INTO telecom.dispositivos_0711(
	registro, id, lat, "long", geom, cdl_provincia, cdl_localidad, 
    zona_serv, barrio, day, hora, cant_lineas)
select * from  registros_insert	

----Dropeo la tabla 				 
 Drop table registros_insert

 ---sigue en 002_creacion_traspaso
				 				 