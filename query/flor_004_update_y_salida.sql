	                ---Actualiza los valores de las semanas pre cuarentena segun corresponda
		  
update  telecom.actualizar_powerbi a set num_semana_precuarentena = 2 
    where num_semana_precuarentena is null and num_semana_actual = '23'

                        ---Cantidad de Lineas conectadas pre cuarentena

update  telecom.actualizar_powerbi a set cant_lineas_precuarentena= b.cant_lineas_precuarentena
    from (Select id_cuadricula, cant_lineas_precuarentena
            from telecom.actualizar_powerbi  where num_semana_precuarentena = '2')b
    where a.num_semana_actual= '23' and a.id_cuadricula=b.id_cuadricula	and  a.cant_lineas_precuarentena is null 

                        --- Actualizo los registros sin valores						
update telecom.actualizar_powerbi a set cant_lineas_precuarentena ='1' 
where num_semana_precuarentena = '2' and cant_lineas_precuarentena='0' and  a.num_semana_actual= '23';

update telecom.actualizar_powerbi a set cant_lineas_precuarentena ='1'
where num_semana_precuarentena ='2' and cant_lineas_precuarentena is null and  a.num_semana_actual= '23';
						
--- Actualizo las fechas de la semana precuarentena
update telecom.actualizar_powerbi set semana_pre_cuarentena = '9/3,10/3,11/3,12/3,13/3'
    where num_semana_actual= '23'
				


                        --Aca termina la actualizacion de los campos Precuarentena--------
		  
update telecom.actualizar_powerbi a set num_semana_anterior = 22 
    where semana_anterior is null and num_semana_actual = '23'
		  
update telecom.actualizar_powerbi a set semana_anterior = b.fecha
    from (
        select fraccion, string_agg (distinct((concat (b.dia,'/',b.mes))),',') as fecha, a.semana,
        round(median (moviles::int)) as mediana
            from antenas.semana_22 a ---aca van los datos de la semana anterior a la semana de analisis
            join  telecom.calendario_2020 b  using (fecha)
                    group by fraccion,a.semana ) b
    where  fraccion= id_cuadricula and  num_semana_actual ='23' and semana_anterior is null
		  
		  
update telecom.actualizar_powerbi a set cant_lineas_semana_anterior= b.mediana
from (
        select fraccion, string_agg (distinct((concat (b.dia,'/',b.mes))),',') as fecha, a.semana,
        round(median (moviles::int)) as mediana
        from antenas.semana_22 a ---aca van los datos de la semana anterior a la semana de analisis
        join  telecom.calendario_2020 b  using (fecha)
        group by fraccion,a.semana 
        ) b
    where  fraccion= id_cuadricula and num_semana_actual ='23' and cant_lineas_semana_anterior is null
		  

update telecom.actualizar_powerbi a set cant_lineas_semana_anterior = '1'
    where num_semana_anterior ='22' and cant_lineas_semana_anterior is null;

update telecom.actualizar_powerbi a set cant_lineas_semana_anterior ='1'
    where num_semana_anterior ='22' and cant_lineas_semana_anterior ='0';

update telecom.actualizar_powerbi a set cant_lineas_actual = '1' 
    where num_semana_actual = '23' and cant_lineas_actual is null;

update telecom.actualizar_powerbi a set cant_lineas_actual = '1' 
    where num_semana_actual = '23' and cant_lineas_actual ='0';

		  
update telecom.actualizar_powerbi a set promedio=b.mediana
    from (
        SELECT  fraccion, round(avg(moviles::int)) mediana,semana
        FROM antenas.semana_23
        group by fraccion,semana) b
    where a.num_semana_actual::int = b.semana and fraccion = id_cuadricula 
    and  num_semana_actual = '23' and promedio is null;

update telecom.actualizar_powerbi  a set promedio = '1' 
    where promedio is null  and num_semana_actual= '23';
update telecom.actualizar_powerbi  a set promedio = '1' 
    where promedio = '0'  and num_semana_actual= '23';
 
						--- Ultimos Updates----
update telecom.actualizar_powerbi  set area_interes= 'N'
    where area_interes is null and num_semana_actual= '23'
						
update telecom.actualizar_powerbi  set tipo_area= 'N'
    where tipo_area is null and num_semana_actual= '23'

update  telecom.actualizar_powerbi set actualizacion = b.fecha
    from (select min (fecha) as fecha 
             from antenas.semana_23 )b
    where actualizacion is null  and num_semana_actual= '23'

update telecom.actualizar_powerbi set descripcion= b.periodo
    from (select concat ((concat (min (dia),'/','0',mes)), ' a ',
                (concat (max (dia),'/','0',mes))) as periodo
            from  telecom.calendario_2020 
            where semana = 23	 and dia_semana not in (6,7) group by mes )b 
    where  num_semana_actual= '23'

update  telecom.actualizar_powerbi a set poblacion_caba= b.poblacion_caba
    from (Select id_cuadricula, poblacion_caba 
            from poblacion_ 
            where poblacion_caba is not null)b
    where a.poblacion_caba is null and a.id_cuadricula=b.id_cuadricula 
    and num_semana_actual= '23'
                    --El resultado de esta consulta la exporto a CSV  y con ella es que actualizo el power bi          
    SELECT  id, id_cuadricula, geom, poblacion_caba, 
            semana_pre_cuarentena, num_semana_precuarentena, cant_lineas_precuarentena, 
            semana_anterior, num_semana_anterior, cant_lineas_semana_anterior, semana_actual,
            num_semana_actual, cant_lineas_actual, tipo_area,
        case when tipo_area = 'Zona Trasbordo' then concat ('CT- ',area_interes)
             when tipo_area != 'Zona Trasbordo' then initcap (area_interes)
             else 'other'
        end area_interes, promedio, actualizacion, descripcion
	FROM telecom.actualizar_powerbi
    
-- NOTA: SI LEISTE HASTA ACA TE FELICITO, HAS GANADO UN CHOCOLATE A ELECCION *VER BASES Y CONDICIONES


