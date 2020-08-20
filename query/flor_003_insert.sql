----inserto los nuevos registros a la tabla... 
---Tengo que excluir los id_cuadricula que intersectan con  las zonas de interes
---- La semana anterior hay que sumarla a la tabla que ya esta, no insertarla porque genera errores
INSERT INTO telecom.actualizar_powerbi(
	id_cuadricula, semana_actual, num_semana_actual, 
	cant_lineas_actual)
	
select fraccion,string_agg (distinct((concat (b.dia,'/',b.mes))),',') as fecha, a.semana,
	round(median (moviles::int)) as mediana
	from telecom.antenas_grilla a
	join  telecom.calendario_2020 b  using (fecha)
	where  dia_semana in (1..5) and hora BETWEEN 10:00 and 17:00 
	group by fraccion,a.semana
--- Estos ids no se insertan porque corresponden corredores/zonas/barrios/subcentros,
--- los aislo e inserto en otras tablas para duplicar los casos compartidos				  

										---Zonas---
INSERT INTO  telecom.incorporar_zonas(
	id_cuadricula, semana_actual, num_semana_actual, 
	cant_lineas_actual)
	
select fraccion,string_agg (distinct((concat (b.dia,'/',b.mes))),',') as fecha, a.semana,
	round(median (moviles::int)) as mediana
	from antenas.semana_23 a
	join  telecom.calendario_2020 b  using (fecha)
	where fraccion IN (
6710,6438,6439,6576,6847,6848,6573,6574,6575,6709,6712,6711,12452,12722,12590,12589,12588,12587,12586,12451,12450,12454,12453,12996,12861,12860,12859,12858,12726,12725,12724,12723,494,495,630,631,765,901,902,1037,1038,13387,13519,13520,13521,13522,13523,13524,13525,12703,13106,13242,12700,12701,12702,12836,12837,12838,12971,12972,12973,12974,13107,13108,13109,13110,13243,13244,13245,13246,13379,13380,13381,13382,13516,13517,13518,13654,13116,13252,13388,13389,13390,13655,13656,13657,13658,13659,13660,13661,13662,13526,12704,12706,12706,12707,12707,12708,12709,12710,12839,12840,12841,12842,12843,12844,12845,12846,12975,12976,12977,12978,12979,12980,12981,12982,13117,13118,13253,13254,13111,13112,13113,13114,13115,13247,13248,13249,13250,13251,13383,13384,13385,13386,10669,10530,10531,10532,10533,10534,10672,10938,10939,10939,10940,10940,10941,10942,10944,11075,11076,11077,11078,11079,11080,10666,10667,10667,10668,10668,10808,10807,10806,10805,10804,10804,10803,10803,10802,10671,10670,8881,9152,9153,9154,9289,9290,9291,9426,9427,8879,8880,766,12705,10943,11074,9015,9016,9017,9563,10673,10536,10535,10400,10399,10264,10263,13378,13511,13512,13510,13240,13241,13374,13375,13376,13377
)	
	group by fraccion,a.semana

									--- Corredores---
INSERT INTO  telecom.incorporar_corredores(
	id_cuadricula, semana_actual, num_semana_actual, 
	cant_lineas_actual)
	
select fraccion,string_agg (distinct((concat (b.dia,'/',b.mes))),',') as fecha, a.semana,
	round(median (moviles::int)) as mediana
	from antenas.semana_23 a
	join  telecom.calendario_2020 b  using (fecha)
	where fraccion IN (
	9866,11355,8214,8079,8078,8077,7939,7804,8215,8076,7941,7940,7803,9869,9870,9871,10006,9867,9868,7104,7515,7241,7106,7105,7378,7377,7242,7379,6969,7514,7651,6831,6422,6421,6420,6559,6558,6557,6696,6695,6694,6147,6283,6284,6285,10247,10112,10111,10110,9975,9974,10385,10384,10248,10248,5380,5379,4702,4294,4565,4430,4429,4566,4838,4837,5109,5108,4973,4972,4701,5245,5244,5243,11898,10946,10675,10674,11354,11762,11627,11626,11491,11490,10811,10810,11219,11218,11083,11082,10947,11750,11612,11613,11614,11748,11749,8894,8347,8346,8345,8210,8209,8757,8892,8893,8756,8484,8483,8482,8621,8620,8619,10113,10249,10382,10668,10383,12163,10531,10667,10667,10668,10803,10803,10804,10804,11755,11619,11483,11484,12434,12435,12570,12571,12706,12706,12707,12707,11211,11212,11347,11348,12027,12162,12298,12299,10939,10939,10940,10940,11075,11076,11891,8217,7671,7806,7807,7808,7943,7944,8080,7945,8081,8216,11092,10954,10955,11229,11090,11091,11093,12573,12433,12436,12437,12438,12165,12569,12572,12574,12302,12164,12166,12167,12301,12303,10797,11068,11067,10933,10932,10932,10931,11204,12292,12293,12428,12429,12564,12565,11884,11885,12020,12021,12156,12157,11205,11340,11341,11476,11477,7809,10659,11069,10796,10795,10658,10523,10522,8485,8891,8755
)
	group by fraccion,a.semana
					
										--- Barrios---
INSERT INTO  telecom.incorporar_barrios(
	id_cuadricula, semana_actual, num_semana_actual, 
	cant_lineas_actual)
	
select fraccion,string_agg (distinct((concat (b.dia,'/',b.mes))),',') as fecha, a.semana,
		round(median (moviles::int)) as mediana
	from antenas.semana_23 a
	join  telecom.calendario_2020 b  using (fecha)
	where fraccion IN (
3376,3377,3378,3506,3507,3508,3509,3510,3511,3512,3642,3643,3644,3645,3646,3647,3648,3779,3780,3781,3782,3783,3784,3915,3916,3917,3918,3919,3920,3925,3926,3927,4053,4054,4055,4056,4060,4061,4062,4063,4189,4190,4191,4197,4198,4199,4333,4334,4335,4952,4953,4995,4996,5088,5130,5131,5132,5133,5134,5135,5266,5267,5268,5269,5270,5271,5403,5404,5416,5417,5495,5496,5550,5551,5552,5553,5554,5555,5618,5630,5631,5686,5687,5688,5689,5690,5691,5698,5699,5754,5822,5823,5824,5825,5826,5834,5835,5957,5958,5959,5960,5961,5962,6093,6094,6095,6096,6229,6230,6300,6301,6436,6437,6493,6573,6574,6627,7844,6628,6629,6630,6632,6762,6763,6764,6765,6766,6767,6768,6769,6898,6899,6900,6901,6902,6903,6904,7034,7035,7036,7037,7038,7039,7170,7172,7173,7435,7436,7437,7571,7572,7573,7574,7707,7708,7709,7710,7845,7846,7980,7981,7982,8115,8116,8117,8118,8252,8253,8388,8389,8524,8525,8660,8661,10837,10838,10916,10973,10974,10975,10976,10977,11052,11053,11110,11111,11112,11113,11114,11115,11116,11189,11190,11245,11246,11247,11248,11249,11250,11251,11252,11253,11325,11326,11380,11381,11382,11383,11384,11385,11386,11387,11388,11389,11464,11516,11517,11518,11519,11520,11521,11522,11523,11525,11526,11600,11651,11652,11653,11654,11655,11656,11657,11658,11659,11660,11661,11662,11787,11788,11798,11872,11873,11922,11923,11924,12008,12009,12010,12144,12145,12146,12280,12281,12282,12283,12416,12417,12418,12419,12553,12554,12555,12556,12690,12691,12692,12693,12827,12828,12829,12830,12962,12963,12964,12965,12966,12967,13098,13099,13100,13101,13103,14893,14894,15029,15030,15040,15041,15042,15165,15300,15301
)
	group by fraccion,a.semana
					
										
										---Subcentros---
INSERT INTO  telecom.incorporar_subcentros(
	id_cuadricula, semana_actual, num_semana_actual, 
	cant_lineas_actual)
	
select fraccion,string_agg (distinct((concat (b.dia,'/',b.mes))),',') as fecha, a.semana,
		round(median (moviles::int)) as mediana
	from antenas.semana_23 a
	join  telecom.calendario_2020 b  using (fecha)
	where fraccion IN (
339,472,473,474,475,476,493,494,495,496,497,608,609,610,611,612,613,629,630,631,632,633,745,746,747,748,749,765,766,767,768,769,882,883,884,901,902,903,904,905,1039,1040,1041,3048,3049,3050,3051,3052,3184,3185,3186,3187,3188,3320,3321,3322,3323,3324,3456,3457,3458,3459,3460,3572,3573,3574,3575,3576,3592,3593,3594,3595,3596,3708,3709,3710,3711,3712,3728,3729,3844,3845,3846,3847,3848,3980,3981,3982,3983,3984,4116,4117,4118,4119,4120,4252,4253,4254,4255,4390,4391,4745,4871,4872,4873,4874,4875,4880,4881,4882,5007,5008,5009,5010,5011,5015,5016,5017,5018,5019,5144,5145,5146,5151,5152,5153,5154,5155,5280,5281,5287,5288,5289,5290,5424,5788,5789,5790,5924,5925,5926,5927,5928,6010,6011,6012,6059,6060,6061,6062,6063,6064,6145,6146,6147,6148,6149,6195,6196,6197,6198,6199,6281,6282,6283,6284,6285,6286,6330,6331,6332,6333,6334,6335,6417,6418,6419,6420,6421,6422,6423,6466,6467,6468,6469,6470,6555,6556,6557,6558,6559,6603,6604,6605,6606,6692,6693,6694,6829,6830,7534,7535,7551,7552,7669,7670,7671,7672,7686,7687,7688,7689,7804,7805,7806,7807,7808,7809,7810,7822,7823,7824,7825,7939,7940,7941,7942,7943,7944,7945,7946,7957,7958,7959,7960,7961,8075,8076,8077,8078,8079,8080,8081,8092,8093,8094,8095,8096,8212,8213,8214,8215,8216,8228,8229,8230,8231,8232,8349,8350,8351,8365,8366,8367,8486,8502,9749,9750,9751,9752,9753,9754,9755,9838,9839,9840,9885,9886,9887,9888,9889,9890,9891,9973,9974,9975,9976,10021,10022,10023,10024,10025,10026,10027,10108,10109,10110,10111,10112,10113,10157,10158,10159,10160,10161,10162,10243,10244,10245,10246,10247,10248,10249,10250,10380,10381,10382,10383,10384,10385,10386,10516,10517,10518,10519,10520,10521,10653,10654,10655,10656,10790,10791,11748,11749,11750,11884,11885,11886,12020,12021,12022,12026,12027,12028,12029,12156,12157,12158,12162,12163,12164,12165,12292,12293,12294,12298,12299,12300,12301,12427,12428,12429,12430,12434,12435,12436,12437,12570,12571,12572,12573,13260,13396,13397,13398,13399,13532,13533,13534,13535,13668,13669,13670,13671,13804,13805,13806,13807,14227,14228,14229,14230,14363,14364,14365,14366,14499,14500,14501,14502,14635,14636,14637,14638
)
				    group by fraccion,a.semana

--- Estas tablas (telecom_incorporar_) son para actualizarle los valores de tipo_area y area_interes, luego de eso
--- vuelven a la tabla actualiza_powerbi 
								----Actualizacion de valores ---

								---ACTUALIZO LAS ZONAS---

update telecom.incorporar_zonas a set tipo_area = b.tipo 
	from (select id,nombre, tipo from public.zonas_ids )b
	where  a.id_cuadricula=b.id and  tipo_area is null

update telecom.incorporar_zonas a set area_interes = b.nombre
	from (select id,nombre, tipo from public.zonas_ids  )b
	where  a.id_cuadricula=b.id and   area_interes is null

	

								--- ACTUALIZO LOS CORREDORES---
update telecom.incorporar_CORREDORES a set tipo_area = b.tipo 
	from (select id,nombre, tipo from public.CORREDORES_ids )b
	where  a.id_cuadricula=b.id::text  and  tipo_area is null

update telecom.incorporar_CORREDORES a set area_interes = b.nombre
	from (select id,nombre, tipo from public.CORREDORES_ids  )b
	where  a.id_cuadricula=b.id::text  and  area_interes is null


								--- ACTUALIZO LOS BARRIOS---

update telecom.incorporar_barrios a set tipo_area = b.tipo 
	from (select id,nombre, tipo from public.barrios_ids )b
	where  a.id_cuadricula=b.id  and  tipo_area is null

update telecom.incorporar_barrios a set area_interes = b.nombre
	from (select id,nombre, tipo from public.barrios_ids  )b
	where  a.id_cuadricula=b.id  and  area_interes is null


				--- ACTUALIZO LOS subcentros

update telecom.incorporar_subcentros a set tipo_area = b.tipo 
	from (select id,nombre, tipo from public.subcentros_ids )b
	where  a.id_cuadricula=b.id  and  tipo_area is null

update telecom.incorporar_subcentros a set area_interes = b.nombre
	from (select id,nombre, tipo from public.subcentros_ids  )b
	where  a.id_cuadricula=b.id  and  area_interes is null


--
								---Es hora que las tablas vuelvan a su lugar

INSERT INTO telecom.actualizar_powerbi(
	  id_cuadricula, geom, poblacion_caba, semana_pre_cuarentena, num_semana_precuarentena, cant_lineas_precuarentena, semana_anterior, num_semana_anterior, cant_lineas_semana_anterior, semana_actual, num_semana_actual, cant_lineas_actual, tipo_area, area_interes, promedio, actualizacion, descripcion)
select   id_cuadricula::int, geom, poblacion_caba::int, semana_pre_cuarentena, 
	num_semana_precuarentena::int, cant_lineas_precuarentena::int, semana_anterior, num_semana_anterior::int,
	cant_lineas_semana_anterior::int, semana_actual, num_semana_actual::int, cant_lineas_actual::int, tipo_area, 
	area_interes, promedio::int, actualizacion, descripcion
from telecom.incorporar_zonas

INSERT INTO telecom.actualizar_powerbi(
	 id_cuadricula, geom, poblacion_caba, semana_pre_cuarentena, num_semana_precuarentena, cant_lineas_precuarentena, semana_anterior, num_semana_anterior, cant_lineas_semana_anterior, semana_actual, num_semana_actual, cant_lineas_actual, tipo_area, area_interes, promedio, actualizacion, descripcion)
select   id_cuadricula::int, geom, poblacion_caba::int, semana_pre_cuarentena, 
	num_semana_precuarentena::int, cant_lineas_precuarentena::int, semana_anterior, num_semana_anterior::int,
	cant_lineas_semana_anterior::int, semana_actual, num_semana_actual::int, cant_lineas_actual::int, tipo_area, 
	area_interes, promedio::int, actualizacion, descripcion
from  telecom.incorporar_corredores

INSERT INTO telecom.actualizar_powerbi(
	 id_cuadricula, geom, poblacion_caba, semana_pre_cuarentena, num_semana_precuarentena, cant_lineas_precuarentena, semana_anterior, num_semana_anterior, cant_lineas_semana_anterior, semana_actual, num_semana_actual, cant_lineas_actual, tipo_area, area_interes, promedio, actualizacion, descripcion)
select   id_cuadricula::int, geom, poblacion_caba::int, semana_pre_cuarentena, 
	num_semana_precuarentena::int, cant_lineas_precuarentena::int, semana_anterior, num_semana_anterior::int,
	cant_lineas_semana_anterior::int, semana_actual, num_semana_actual::int, cant_lineas_actual::int, tipo_area, 
	area_interes, promedio::int, actualizacion, descripcion
from  telecom.incorporar_barrios 

INSERT INTO telecom.actualizar_powerbi(
	 id_cuadricula, geom, poblacion_caba, semana_pre_cuarentena, num_semana_precuarentena, cant_lineas_precuarentena, semana_anterior, num_semana_anterior, cant_lineas_semana_anterior, semana_actual, num_semana_actual, cant_lineas_actual, tipo_area, area_interes, promedio, actualizacion, descripcion)
select   id_cuadricula::int, geom, poblacion_caba::int, semana_pre_cuarentena, 
	num_semana_precuarentena::int, cant_lineas_precuarentena::int, semana_anterior, num_semana_anterior::int,
	cant_lineas_semana_anterior::int, semana_actual, num_semana_actual::int, cant_lineas_actual::int, tipo_area, 
	area_interes, promedio::int, actualizacion, descripcion
from  telecom.incorporar_subcentros 

truncate telecom.incorporar_subcentros;
truncate telecom.incorporar_barrios;
truncate telecom.incorporar_zonas;
truncate telecom.incorporar_corredores;




					