										--TARDE SEMANA--
INSERT INTO regeneracion.tablero_powerbi (
	id_cuadricula, semana,franja,  dispositivos_semana)

select fraccion, a.semana, '2-Tarde',
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (5,6,7,8) and 
		 hora  between '15:30' and '17:00'
		 AND A.SEMANA = ()-- numero de semana en cuestion
	group by fraccion,a.semana;
	

									---TARDE  FINDE ---	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET findsemana = b.semana,
    	franja_finde= '2-Tarde',
    	dispositivos_finde= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '15:30' and '17:00' 
					AND A.SEMANA = ()-- numero de semana en cuestion
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion  and b.semana::text= a.semana::text and franja= '2-Tarde'
											and dispositivos_finde is null;
	
---------------------------TARDE anterior semana--------------------------------	
											
UPDATE 	regeneracion.tablero_powerbi a
	SET semana_anterior = b.semana,
    	franja_semaant= '2-Tarde',
    	dispositivos_seman_ante= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana not IN (5,6,7,8) and 
					hora  between '15:30' and '17:00'
					AND A.SEMANA = 28--- numero semana anterior
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion and franja_semaant is null
		and dispositivos_seman_ante is null and A.SEMANA = ();-- numero de semana en cuestion
	
										---TARDE anterior findesemana---	
UPDATE 	regeneracion.tablero_powerbi a
	SET find_anterior = b.semana,
    	franja_findeante= '2-Tarde',
    	dispositivos_findeanter= b.n_lineas
	from 
			(select fraccion, a.semana, 
					round(median (a.moviles::int)) as n_lineas
			from telecom.proyecto a
			left  join telecom.calendario_2020 c using (fecha)
			where c.dia_semana IN (5,6,7,8) and 
					hora between '15:30' and '17:00'
					AND A.SEMANA =28--- num semana anterior
			group by fraccion,a.semana)b
	where a.id_cuadricula= b.fraccion and dispositivos_findeanter is null
			 and A.SEMANA = ();-- numero de semana en cuestion
		
