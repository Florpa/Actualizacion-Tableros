										--MEDIODIA SEMANA--
INSERT INTO regeneracion.tablero_powerbi (
	id_cuadricula, semana,franja,  dispositivos_semana)

select fraccion, a.semana, '1-Mediodia',
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (5,6,7,8) and 
		 hora between '11:00' and '15:00' 
		 AND A.SEMANA = ()-- numero de semana en cuestion
	group by fraccion,a.semana;
	

									---MEDIO DIA FINDE ---	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET findsemana = b.semana,
    	franja_finde= '1-Mediodia',
    	dispositivos_finde= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '11:00' and '15:00' 
					AND A.SEMANA  A.SEMANA = ()-- numero de semana en cuestion
			group by fraccion,a.semana)b
	 where a.id_cuadricula= b.fraccion  and b.semana::text= a.semana::text and franja= '1-Mediodia'
											and dispositivos_finde is null;
	
---------------------------Mediodia anterior semana--------------------------------	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET semana_anterior = b.semana,
    	franja_semaant= '1-Mediodia',
    	dispositivos_seman_ante= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana not IN (5,6,7,8) and 
					hora between '11:00' and '15:00' 
					AND A.SEMANA = 28-- numero semana anterior
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion and dispositivos_seman_ante is null
			 					and a. A.SEMANA = ();-- numero de semana en cuestion
	
										---Mediodia anterior findesemana---	
UPDATE 	regeneracion.tablero_powerbi a
	SET find_anterior = b.semana,
    	franja_findeante= '1-Mediodia',
    	dispositivos_findeanter= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '11:00' and '15:00' 
					AND A.SEMANA =28 -- numero semana anterior
			group by fraccion,a.semana)b 
	where a.id_cuadricula= b.fraccion  and dispositivos_findeanter is null
							 and  A.SEMANA = ();-- numero de semana en cuestion
		
