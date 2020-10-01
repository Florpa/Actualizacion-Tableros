--- Creo una tabla con el los valores de la semana a procesar
--- Para el tablero de Concentracion de Personas el parametro es 
---- semana habil de 10:00 a 17:00

create table antenas.semana_22 as
with 
antenas as (
		select st_transform(geom,5347) as geom, day, sum(cant_lineas)*3.3 AS lineas,hora
		from 
		telecom.dispositivos_0711 a
		where  hora BETWEEN '10:00'AND '17:00' 
	and day between '2020-07-28'and '2020-07-31'  
		group by  geom, day,hora
		order by hora),
calendario as(
	select pk_fecha,fecha,semana,dia_semana,dia,mes,dia_semana_nombre,feriado
	 	from telecom.calendario_2020),
voro as (---Segundo input poligonos voronoi
		select x.geom, b.lineas as moviles, day, hora from (SELECT 
		 (ST_DUMP(ST_VoronoiPolygons(ST_Collect(geom)))).geom as geom
		from antenas)x 
		inner join antenas b on st_within (b.geom, x.geom) ),
caba as (----Tercer input es el poligono de caba para cortar---
		Select st_transform(st_union(geom),5347) as geom from flor.radios_caba),
vorointer as (----Poligonos de voronoi cortados por el limite de caba
			select st_intersection(b.geom,a.geom) as geom, moviles, day, 
            hora,st_area(st_intersection(b.geom,a.geom)) as tarea 
			from voro a
			inner join caba b on st_intersects(a.geom, b.geom)),
fraccion as (--Grilla
			select st_transform(geom,5347) as geom,id as fraccion from general.cuadrado_150),
vorofrac as (--- A cada radios le asigno el los valores del poligono de voronoi segun correponda---
			select ST_Intersection(a.geom, b.geom) as geom, a.fraccion, moviles, tarea,day, hora, 
			st_area(ST_Intersection(a.geom, b.geom)) as 
			farea from fraccion a
			inner join vorointer  b on st_intersects(a.geom, b.geom)) ,													  
combi as ( --- une nuevamente los poligonos de las fracciones
			select  GEOM,
			FRACCION, MOVILES, tarea, ((farea *100)/tarea) as porarea, ((farea*moviles)/tarea) 
            as fantena,day, hora 
			from vorofrac),
presalida as (---Asigna los valores de las lineas conectadas  segun corresponda----
			select st_union(geom) as geom, fraccion, round(sum(fantena)) as moviles, day, hora
			from combi
			group by fraccion,day, hora),
salida as (---Reproyecto la informacion de salida y calculo la densidad de lineas conectadas
		select st_transform(geom,4326) as geom,fraccion,moviles,day,hora
		from presalida)													
				
select fraccion,b.fecha,hora,moviles,b.semana
from salida a 
join calendario b on a.day=b.fecha		

--Esto mismo se puede hacer en Python. Buscar en "Generacion_antenas_cuadriculas"
--