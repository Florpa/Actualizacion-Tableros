	                ---Actualiza los valores de las semanas pre cuarentena segun corresponda
update  telecom.actualizar_powerbi a set num_semana_precuarentena = 2 
    where num_semana_precuarentena is null and num_semana_actual = '30'

                        ---Cantidad de Lineas conectadas pre cuarentena

update  telecom.actualizar_powerbi a set cant_lineas_precuarentena= b.n_lineas
    from 	(select fraccion, a.semana, 
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (5,6,7,8) 
	and hora between '10:00' and '17:00' and  c.semana= 2
			group by fraccion,a.semana)b
			where
     a.id_cuadricula=b.fraccion	 and num_semana_actual = '30'
and  a.cant_lineas_precuarentena is null 

                        --- Actualizo los registros sin valores						
update telecom.actualizar_powerbi a set cant_lineas_precuarentena = 1 
where num_semana_precuarentena = '2' and cant_lineas_precuarentena= 0 and  a.num_semana_actual= '30';

update telecom.actualizar_powerbi a set cant_lineas_precuarentena ='1'
where num_semana_precuarentena ='2' and cant_lineas_precuarentena is null and  a.num_semana_actual= '30';
						

-------------------------------------------------------------------------------------------------------				
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
                        --Aca termina la actualizacion de los campos Precuarentena--------
-------------------------------------------------------------------------------------------------------		  
update telecom.actualizar_powerbi a set num_semana_anterior = 29
    where semana_anterior is null and num_semana_actual = 30
		  
update telecom.actualizar_powerbi a set cant_lineas_semana_anterior = b.n_lineas
	from (	select fraccion, a.semana, 
			   		round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana NOT IN (5,6,7,8) and a.semana=27
			and hora between '10:00' and '17:00'
		 	group by fraccion,a.semana) b
    where  fraccion= id_cuadricula and a.num_semana_anterior= b.semana
		  
		  

update telecom.actualizar_powerbi a set cant_lineas_semana_anterior = '1'
    where  cant_lineas_semana_anterior is null;

update telecom.actualizar_powerbi a set cant_lineas_semana_anterior ='1'
    where  cant_lineas_semana_anterior ='0';

update telecom.actualizar_powerbi a set cant_lineas_actual = '1' 
    where  cant_lineas_actual is null;

update telecom.actualizar_powerbi a set cant_lineas_actual = '1' 
    where cant_lineas_actual ='0';


						--- Ultimos Updates----


update telecom.actualizar_powerbi  a set actualizacion ='25/9/2020'
	where num_semana_actual=30
		from (select to_char(min (fecha), 'DD/MM/YYYY') as fecha,semana::text 
			  	from telecom.proyecto 
	  			where semana=25
			  	group by semana)b
		where actualizacion is null  and b.semana=a.num_semana_actual::text;

update telecom.actualizar_powerbi a set descripcion='21/09 a 25/09'
	where num_semana_actual=30
		from (select concat (to_char(min (fecha), 'DD/MM'),' a ',
			  		to_char(max (fecha), 'DD/MM'))as periodo,a.semana::text 
			  	from telecom.proyecto a
			  	left  join telecom.calendario_2020 c using (fecha)
	  			where a.semana= 25
			  	and c.dia_semana not in (6,7,8)
			  			group by a.semana)b 
		where b.semana=a.num_semana_actual::text
		  
		  
update  telecom.actualizar_powerbi a set poblacion_caba= b.n_lineas
    from (select fraccion, a.semana, 
			   		round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana NOT IN (5,6,7,8) and a.semana=30
			and hora ='4:00'
		 	group by fraccion,a.semana)b
    where a.poblacion_caba is null and a.id_cuadricula=b.fraccion
  	and b.semana=a.num_semana_actual
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
                    --El resultado de esta consulta la exporto a CSV  y con ella es que actualizo el power bi  
------------------------------------------------------------------------------------------------------------------
--create table semana_26 as
SELECT  id, id_cuadricula, geom, poblacion_caba, 
            semana_pre_cuarentena, num_semana_precuarentena, cant_lineas_precuarentena, 
            semana_anterior, num_semana_anterior, cant_lineas_semana_anterior, semana_actual,
            num_semana_actual, cant_lineas_actual,
			case when b.tipo is null then 'N'
				else b.tipo
				end tipo_area,
        	case when b.tipo = 'Zona Trasbordo' then concat ('CT- ',b.nombre)
             	 when b.tipo != 'Zona Trasbordo' then initcap (b.nombre)
				 when b.tipo is null then 'N'
				 else nombre
        end area_interes, 
		promedio, actualizacion, descripcion
	FROM telecom.actualizar_powerbi a
	LEFT JOIN telecom.zonas_interes b on b.id_grilla=a.id_cuadricula
	where num_semana_actual in (30)
	
	
	
/*SELECT  count(id_cuadricula)as grilla,
sum (poblacion_caba) as poblacion,sum(cant_lineas_precuarentena) pre, 
sum (cant_lineas_semana_anterior) anterior,
num_semana_actual,sum(cant_lineas_actual)semana_act
	FROM telecom.actualizar_powerbi
	group by num_semana_actual
	order by num_semana_actual desc
*/


update telecom.actualizar_powerbi a set cant_lineas_semana_anterior = b.n_lineas
from (select id_cuadricula,num_semana_actual,cant_lineas_actual as n_lineas
	  from sem_29)b
	  where a.id_cuadricula=b.id_cuadricula and a.num_semana_actual= 30
	  
update telecom.actualizar_powerbi  set cant_lineas_actual= 1
	where num_semana_actual= 30 and cant_lineas_actual= 0
	
	create table sem_29 as 
	select * from telecom.actualizar_powerbi 
	where num_semana_actual= 29
	


	

