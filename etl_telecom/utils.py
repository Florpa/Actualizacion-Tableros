
# -*- coding: UTF-8 -*-

import psycopg2

def increment_staged_data(source_table, sink_table, con):

    cur = con.cursor()

    query_max_date = """
    SELECT MAX(dia) 
    FROM """ + sink_table + """;
    """
    cur.execute(query_max_date)
    print(query_max_date)
    max_fecha = cur.fetchall()
    print(max_fecha)

    query_3 = """
    INSERT INTO """ + sink_table + """
    AS
    SELECT a.dia::date dia,
            a.hora,
            ST_SetSRID(ST_MakePoint(a.long, a.lat), 4326) geom_4326,
            ST_Transform(ST_SetSRID(ST_MakePoint(a.long, a.lat), 4326), 5347) geom_5347,
            n_lineas
    FROM """ + source_table + """ a
    WHERE a.dia::date > """ + max_fecha + """
    ORDER BY a.dia;
    """
    # hago insert into
    # confirmar si preciso también hacer create table en otro lugar
    # quizás sirva agregar una columna con la fecha de carga de esa fila, por si quisiera acceder a 'lo que se cargó en tal fecha'

    cur.execute(query_3)
    print(query_3)
    
    # los commit y close los hago al final del main, no en cada lugar.
    # validar que esto está OK
    # connection.commit()
    # cur.close()
    # connection.close()

    return True


def increment_antenas(source_table, sink_table, dates, con):
        
    cur = con.cursor()

    # creo que en esta query no debería haber rangos horarios, pues estoy incrementando staged_data

    query_antenas = """
        INSERT INTO """ + sink_table + """
        AS
        WITH

        antenas as (
        SELECT a.geom_5347,
                a.dia,
                a.hora,
                SUM(a.n_lineas)*3.3 AS n_lineas
        FROM """ + source_table + """ a
        WHERE a.hora BETWEEN '10:00' AND '17:00' AND
            a.dia BETWEEN '2020-07-28' AND '2020-07-31'
        -- no sé si ya quiero filtrar por hora, creo que eso lo haría para el output de un tablero específico
        GROUP BY a.geom,
                a.dia,
                a.hora
        -- ORDER BY a.hora
        -- no estoy seguro de que sea necesario este GROUP BY
        ),
        
        calendario as (
	SELECT a.pk_fecha, a.fecha, a.semana, a.dia_semana, a.dia, a.mes,dia_semana_nombre, feriado
        FROM aux.calendario_2020 a
        -- es posible que haya cambiado day por dia y no exista el campo dia
        ),
        
        voro as (
        -- Segundo input poligonos voronoi
        SELECT a.geom, b.lineas as moviles, dia, hora
        -- acá dia y hora también salen de a? (antes a era x)
        FROM (SELECT 
                (ST_DUMP(ST_VoronoiPolygons(ST_Collect(a_a.geom)))).geom as geom
                -- no comprendo el ".geom" pero parece válido
		FROM antenas a_a) a 
        INNER JOIN antenas b on ST_Within(b.geom, a.geom)),
        
        caba as (
        -- Polígono de caba para cortar
        SELECT ST_Transform(ST_union(a.geom), 5347) as geom
        FROM aux.radios_caba a
        -- es posible que esto tenga huecos, quizás ya tener armado polígono con huecos rellenos de ser necesario
        ),
        
        vorointer as (
        -- Polígonos de Voronoi cortados por el límite de caba
        SELECT ST_Intersection(b.geom, a.geom) as geom, a.moviles, a.dia, a.hora, ST_Area(ST_Intersection(b.geom, a.geom)) as t_area
        FROM voro a
        INNER JOIN caba b on ST_Intersects(a.geom, b.geom)),
        
        grilla as (
        -- grilla / unidad espacial
        SELECT ST_Transform(geom, 5347) as geom, id as id_grilla
        FROM aux.cuadrado_150),
        
        vorofrac as (
        -- A cada radios le asigno el los valores del poligono de voronoi según corresponda
        SELECT ST_Intersection(a.geom, b.geom) as geom, a.id_grilla, b.moviles, b.t_area, b.dia, b.hora, ST_Area(ST_Intersection(a.geom, b.geom)) as f_area
        FROM grilla a
        INNER JOIN vorointer b on ST_Intersects(a.geom, b.geom)), 
        
        combi as (
        -- une nuevamente los poligonos de los diferentes id_grilla
        SELECT a.geom, a.id_grilla, a.moviles, a.t_area, ((a.f_area*100)/a.t_area) as porc_area, ((a.f_area*a.moviles)/a.t_area) as f_antena,dia, hora
        FROM vorofrac a),
        
        presalida as (
        -- Asigna los valores de las lineas conectadas  segun corresponda
        SELECT a.id_grilla, a.dia, a.hora, ST_Union(a.geom) as geom, ROUND(SUM(a.f_antena)) as moviles
        FROM combi a
        GROUP BY a.id_grilla, a.dia, a.hora),
        
        salida as (
        -- Reproyecto la informacion de salida y calculo la densidad de líneas conectadas
        SELECT ST_Transform(a.geom, 4326) as geom, a.id_grilla, a.moviles, a.dia, a.hora
        FROM presalida a)

        SELECT a.id_grilla,
                a.dia,
                a.hora,
                a.moviles,
                b.semana
        FROM salida a
        JOIN calendario b on a.dia = b.fecha;
        -- dia ya tiene formato date, cierto?
        -- acá b.fecha y a.dia son equivalentes, sólo estoy uniendo la semana
        """

    cur.execute(query_antenas)
    print(query_antenas)
    
    # los commit y close los hago al final del main, no en cada lugar.
    # validar que esto está OK
    # connection.commit()
    # cur.close()
    # connection.close()

    return True

