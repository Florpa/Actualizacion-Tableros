# -*- coding: UTF-8 -*-

'''

etl_telecom

Tomo datos de una tabla del postgres y muevo cosas hasta tener actualizada la tabla que actualiza el tablero.

'''

import psycopg2
import sys
import datetime
from .config import *

RETURN_EXITOSO = True

def main():

    print("--- Inicio del script ---")

    print("pg user:", godatos_pg_user)
    print("pg pw:", godatos_pg_password)
    print("pg host:", godatos_pg_host)
    print("pg port:", godatos_pg_port)
    print("pg db name:", godatos_pg_db_name)

    print("--- Inicio del procesamiento ---")

    # Abre la coneccion y la request
    connection = psycopg2.connect(user = godatos_pg_user,
                                password = godatos_pg_password,
                                host = godatos_pg_host,
                                port = godatos_pg_port,
                                database = godatos_pg_db_name)

    cur = connection.cursor()
    print("Conectado.")

    print(datetime.datetime.today())

    query_1 = "SELECT DAY FROM telecom.dispositivos_0711 where day > (select max(fecha) from telecom.proyecto) GROUP BY day order by day;"
    query_1 = "SELECT * FROM datos.sample_telecom LIMIT 100;"
    # poner nombre descriptivo a query
    cur.execute(query_1)
    print(query_1)
    fechas = cur.fetchall()
    print(fechas)

    postgis_love = "CREATE EXTENSION IF NOT EXISTS postgis;"
    print(postgis_love)
    cur.execute(postgis_love)
    # esto solo se corre la primera vez, tururú.
    
    add_geom = "ALTER TABLE datos.sample_telecom ADD COLUMN geom geometry;"
    print(add_geom)
    cur.execute(add_geom)

    # query_2 = "select distinct(HORA::time) FROM telecom.dispositivos_0711 group by hora::time order by 1 asc"
    query_2 = "UPDATE datos.sample_telecom SET geom = ST_SETSRID(ST_POINT(uli_sitiorm_longitud, uli_sitiorm_latitud), 4326)"
    print(query_2)
    # poner nombre descriptivo a query
    cur.execute(query_2)

    query_3 = "SELECT geom FROM datos.sample_telecom LIMIT 5;"
    print(query_3)
    cur.execute(query_3)
    top_geoms = cur.fetchall()

    print(top_geoms)

    """
    for fecha in fechas:

        fecha = (str(fecha[0]))
        
        for hora in horas:

            hora = (str(hora[0]))
            
            cur.execute("with antenas as (select st_transform(geom,5347) as geom, day, sum(cant_lineas)*3.3 AS lineas,hora from telecom.dispositivos_0711 a where  hora::time = '" + hora + "' and day = '"+fecha+"' group by  geom, day,hora order by hora),calendario as( select pk_fecha,fecha,semana,dia_semana,dia,mes,dia_semana_nombre,feriado from telecom.calendario_2020),voro as (select x.geom, b.lineas as moviles, day, hora from (SELECT (ST_DUMP(ST_VoronoiPolygons(ST_Collect(geom)))).geom as geom from antenas)x inner join antenas b on st_within (b.geom, x.geom) ),caba as ( Select st_transform(st_union(geom),5347) as geom from flor.radios_caba),vorointer as (select st_intersection(b.geom,a.geom) as geom, moviles, day, hora,st_area(st_intersection(b.geom,a.geom)) as tarea  from voro a inner join caba b on st_intersects(a.geom, b.geom)), fraccion as (select st_transform(geom,5347) as geom,id as fraccion from  general.cuadrado_150),vorofrac as (select ST_Intersection(a.geom, b.geom) as geom, a.fraccion, moviles, tarea,day, hora, st_area(ST_Intersection(a.geom, b.geom)) as  farea from fraccion a inner join vorointer  b on st_intersects(a.geom, b.geom)) ,combi as ( select  GEOM, FRACCION, MOVILES, tarea, ((farea *100)/tarea) as porarea, ((farea*moviles)/tarea) as fantena,day, hora  from vorofrac),presalida as (select st_union(geom) as geom, fraccion, round(sum(fantena)) as moviles, day, hora from combi group by fraccion,day, hora),salida as (select st_transform(geom,4326) as geom,fraccion,moviles,moviles/(st_area(geom)/1000000) as densidad,day,hora from presalida),insertar as (insert into telecom.proyecto (fraccion, fecha, hora, moviles, semana)select fraccion,b.fecha,hora,moviles,b.semana from salida a join calendario b on a.day=b.fecha)select count(*) from telecom.proyecto")
            
            connection.commit()
        
        print('Finalizado:', fecha)
    """
    
    connection.commit()
    
    cur.close()

    connection.close()

    return RETURN_EXITOSO

if __name__ == '__main__':
    main()
