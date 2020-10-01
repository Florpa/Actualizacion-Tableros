--Luego de subir el txt  al postgres, hay que generarle la columna de geom.

alter table telecom.mitablanueva add column geom geometry 

---- para hacer el insert me fijo la ultima fecha que tengo resgitrada 
select max (day::date) from telecom.mitablahistorica

---Chequeo que esten los dias que necesito a partir de la ultima fecha de registro
select distinct (day::date) 
from telecom.mitablanueva
where day::date > (resultado del max date) order by day 


--- Creo una tabla intermedia seteando los campos que necesito. Hoy por hoy guardo todos los campos.
--- no son ultiles por el momento, pero nunca se sabe...
create table registros_insert as
SELECT id_2 as registro, uli_sitiorm_latitud as lat, uli_sitiorm_longitud as 
long,(ST_SetSRID(ST_MakePoint(uli_sitiorm_longitud , uli_sitiorm_latitud),4326))as geom,
cdl_provincia, cdl_localidad, 
sitiorm_agrupador_zona_de_servic as zona_serv, barrio,day::date,hora,lineas as cant_lineas
FROM telecom.dispositivos_2709 
where  day::date > (resultado del max date) order by day

---- Chequeo cuandos registros hay por dia. 

select distinct (day), count (*) 
from registros_insert
group by 1
order by day	 

--Inserto los valores nuevos en mi tabla historial 
				 
INSERT INTO telecom.mitablahistorica(
	registro, lat, "long", geom, cdl_provincia, cdl_localidad, zona_serv, barrio, day, hora, cant_lineas)
select * from  registros_insert	


 Drop table registros_insert; 
 

				 				 
				 


