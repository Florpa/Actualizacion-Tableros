
INSERT INTO telecom.actualizar_powerbi(
	id_cuadricula, num_semana_actual, 
	cant_lineas_actual)
	
select fraccion, a.semana, 
	   round(median (a.moviles::int)) as n_lineas
	from telecom.proyecto a
	left  join telecom.calendario_2020 c using (fecha)
	where c.dia_semana NOT IN (6,7,8)  and a.semana= 30
	and hora between '10:00' and '17:00' 
	group by fraccion,a.semana
