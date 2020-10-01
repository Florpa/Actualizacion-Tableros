										--NOCHE SEMANA--
INSERT INTO regeneracion.tablero_powerbi (
	id_cuadricula, semana,franja,  dispositivos_semana)

select fraccion, a.semana, '3-Noche',
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (5,6,7,8) and 
		 hora between '17:30' and '23:00'
		 AND A.SEMANA = ()-- numero de semana en cuestion
	group by fraccion,a.semana;
	

									---NOCHE FINDE ---	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET findsemana = b.semana,
    	franja_finde= '3-Noche',
    	dispositivos_finde= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '17:30' and '23:00'
					AND A.SEMANA = ()-- numero de semana en cuestion
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion  and b.semana::text= a.semana::text and franja= '3-Noche'
											and dispositivos_finde is null;
	
---------------------------NOCHE anterior semana--------------------------------	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET semana_anterior = b.semana,
    	franja_semaant='3-Noche',
    	dispositivos_seman_ante= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana not IN (5,6,7,8) and 
					hora between '17:30' and '23:00'
					AND A.SEMANA = 29--- numero semana anterior
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion
		and dispositivos_seman_ante is null AND A.SEMANA = ()-- numero de semana en cuestion
	
										---NOCHE anterior findesemana---	
UPDATE 	regeneracion.tablero_powerbi a
	SET find_anterior = b.semana,
    	franja_findeante= '3-Noche',
    	dispositivos_findeanter= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '17:30' and '23:00'
					AND A.SEMANA = 29 --- numero semana anterior
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion
			and dispositivos_findeanter is null and AND A.SEMANA = ()-- numero de semana en cuestion
			
			