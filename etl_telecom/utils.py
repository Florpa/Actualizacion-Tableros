
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
            ST_SetSRID(ST_MakePoint(a.long, a.lat), 4326) geom,
            n_lineas
    FROM """ + source_table + """ a
    WHERE a.dia::date > """ + max_fecha + """
    ORDER BY a.dia;
    """
    # hago insert into
    # confirmar si preciso también hacer create table en otro lugar
    cur.execute(query_3)
    print(query_3)
    
    # los commit y close los hago al final del main, no en cada lugar.
    # validar que esto está OK
    # connection.commit()
    # cur.close()
    # connection.close()

    return(True)


