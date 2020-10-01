

SELECT  id_cuadricula, poblacion, semana, franja, dispositivos_semana, 
findsemana, franja_finde, dispositivos_finde, semana_anterior, franja_semaant,
dispositivos_seman_ante, find_anterior, franja_findeante, dispositivos_findeanter, 
semanprecu, franja_pre, dispositivo_semaprec, prefindsemana, 
franja_prefinde, dispositivo_findprec, poblacion_pre,
	case when b.nombre is not null then b.nombre
			 when b.nombre is null then 'N'
			 else 'other'
			 end zona_interes,
actualizacion, descripcion
FROM regeneracion.tablero_powerbi a 
	LEFT JOIN regeneracion.zonas b on  b.id= a.id_cuadricula
	where semana= 
	order by actualizacion
	

