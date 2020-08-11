# borra

import psycopg2
import sys
import datetime


# Abre la coneccion y la request
connection = psycopg2.connect(user="postgres",
                              password="chirus2020",
                              host="localhost",
                              port="5433",
                              database="postgres")

cur = connection.cursor()
print("conectado")

print(datetime.datetime.today())
cur.execute("SELECT DAY FROM telecom.dispositivos_0711 where day > (select max(fecha) from telecom.proyecto)GROUP BY day order by day")
fechas = cur.fetchall()
cur.execute(
    "select distinct(HORA::time) FROM telecom.dispositivos_0711 group by hora::time order by 1 asc")
horas = cur.fetchall()
  
for fecha in fechas:
    fecha = (str(fecha[0]))
    for hora in horas:
        hora = (str(hora[0]))
        cur.execute("with antenas as (select st_transform(geom,5347) as geom, day, sum(cant_lineas)*3.3 AS lineas,hora from telecom.dispositivos_0711 a where  hora::time = '"+hora+"' and day = '"+fecha+"' group by  geom, day,hora order by hora),calendario as( select pk_fecha,fecha,semana,dia_semana,dia,mes,dia_semana_nombre,feriado from telecom.calendario_2020),voro as (select x.geom, b.lineas as moviles, day, hora from (SELECT (ST_DUMP(ST_VoronoiPolygons(ST_Collect(geom)))).geom as geom from antenas)x inner join antenas b on st_within (b.geom, x.geom) ),caba as ( Select st_transform(st_union(geom),5347) as geom from flor.radios_caba),vorointer as (select st_intersection(b.geom,a.geom) as geom, moviles, day, hora,st_area(st_intersection(b.geom,a.geom)) as tarea  from voro a inner join caba b on st_intersects(a.geom, b.geom)), fraccion as (select st_transform(geom,5347) as geom,id as fraccion from  general.cuadrado_150),vorofrac as (select ST_Intersection(a.geom, b.geom) as geom, a.fraccion, moviles, tarea,day, hora, st_area(ST_Intersection(a.geom, b.geom)) as  farea from fraccion a inner join vorointer  b on st_intersects(a.geom, b.geom)) ,combi as ( select  GEOM, FRACCION, MOVILES, tarea, ((farea *100)/tarea) as porarea, ((farea*moviles)/tarea) as fantena,day, hora  from vorofrac),presalida as (select st_union(geom) as geom, fraccion, round(sum(fantena)) as moviles, day, hora from combi group by fraccion,day, hora),salida as (select st_transform(geom,4326) as geom,fraccion,moviles,moviles/(st_area(geom)/1000000) as densidad,day,hora from presalida),insertar as (insert into telecom.proyecto (fraccion, fecha, hora, moviles, semana)select fraccion,b.fecha,hora,moviles,b.semana from salida a join calendario b on a.day=b.fecha)select count(*) from telecom.proyecto")
        connection.commit()
    print('Finalizado:', fecha)

print(datetime.datetime.today())

cur.close()
connection.close()
