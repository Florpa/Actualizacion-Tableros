--------------------------------------------semana pre cuanrentena---
UPDATE 	regeneracion.tablero_powerbi a
	SET 
    	poblacion_pre= b.n_lineas
		
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana  IN (5,6,7,8) and 
					hora = '04:00'
					AND A.SEMANA =2
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion and poblacion_pre is null and AND A.SEMANA = ()-- numero de semana en cuestion

-------------------------------------------------------------------------------------------------


										--MEDIODIAPRE SEMANA--
update regeneracion.tablero_powerbi a set
semanprecu =b.semana,
franja_pre= '1-Mediodia',
dispositivo_semaprec= n_lineas
from (
	select fraccion, a.semana, 
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (5,6,7,8) and 
		 hora between '11:00' and '15:00' 
		 AND A.SEMANA =2
	group by fraccion,a.semana) b
	where a.id_cuadricula=b.fraccion and  a.franja= '1-Mediodia'and AND A.SEMANA = ()-- numero de semana en cuestion
	

									---MEDIODIA PRE FINDE ---	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET prefindsemana = b.semana,
    	franja_prefinde= '1-Mediodia',
    	dispositivo_findprec= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '11:00' and '15:00' 
					AND A.SEMANA =2
			group by fraccion,a.semana)b
		where a.id_cuadricula=b.fraccion  and a.franja= '1-Mediodia'AND A.SEMANA = ()-- numero de semana en cuestion
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------TARDE SEMANAPRE

update regeneracion.tablero_powerbi a set
semanprecu =b.semana,
franja_pre= '2-Tarde',
dispositivo_semaprec= n_lineas
from (
	select fraccion, a.semana, 
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (5,6,7,8) and 
		 hora  between '15:30' and '17:00'
		 AND A.SEMANA =2
	group by fraccion,a.semana) b
	where a.id_cuadricula=b.fraccion and a.franja= '2-Tarde' AND A.SEMANA = ()-- numero de semana en cuestion
	

									---TARDE PRE FINDE ---	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET prefindsemana = b.semana,
    	franja_prefinde= '2-Tarde',
    	dispositivo_findprec= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '15:30' and '17:00'
					AND A.SEMANA =2
			group by fraccion,a.semana)b
	where a.id_cuadricula=b.fraccion  and a.franja= '2-Tarde'AND A.SEMANA = ()-- numero de semana en cuestion
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------NOCHE SEMANAPRE

update regeneracion.tablero_powerbi a set
semanprecu =b.semana,
franja_pre= '3-Noche',
dispositivo_semaprec= n_lineas
from (
	select fraccion, a.semana, 
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (5,6,7,8) and 
		 hora   between '17:30' and '23:00'
		 AND A.SEMANA =2
	group by fraccion,a.semana) b
	where a.id_cuadricula=b.fraccion and a.franja= '3-Noche' AND A.SEMANA = ()-- numero de semana en cuestion
	

									---TARDE PRE FINDE ---	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET prefindsemana = b.semana,
    	franja_prefinde= '3-Noche',
    	dispositivo_findprec= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora  between '17:30' and '23:00'
					AND A.SEMANA =2
			group by fraccion,a.semana)b
	where a.id_cuadricula=b.fraccion and a.franja= '3-Noche' AND A.SEMANA = ()-- numero de semana en cuestion




update regeneracion.tablero_powerbi a set actualizacion= '20/09/2020'
where semana=29

update regeneracion.tablero_powerbi a set descripcion= '14/09 a 20/09'
where semana= 29


		


