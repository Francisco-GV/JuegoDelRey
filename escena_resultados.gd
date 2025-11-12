extends Control


func _ready() -> void:
	if not DB or DB.db == null:
		print("Error: El gestor de base de datos no está inicializado")
		return

	var query: String = """
    SELECT j.nombre         AS "nombre",
       j.edad               AS "edad",
       j.genero             AS "genero",
       j.imagen             AS "imagen",
       m.rey                AS "monedas_rey",
       m.madre              AS "monedas_madre",
       m.anciano            AS "monedas_anciano",
       m.nino_pobre         AS "monedas_nino_pobre",
       m.mujer_trabajadora  AS "monedas_mujer_trabajadora",
       m.joven              AS "monedas_joven",
       m.nino_discapacitado AS "monedas_nino_discapacitado",
       m.perro              AS "monedas_perro",
       p.fecha_guardado     AS "fecha_guardado"
    FROM partida AS p
       JOIN jugador AS j
         ON p.id_jugador = j.id
       JOIN jugador_monedas AS m
         ON j.id_monedas = m.id
    """

	var success: bool = DB.db.query(query)

	if not success:
		print("Error: No se pudo ejecutar la consulta para obtener los resultados.")
		return

	var results = DB.db.query_result

	print("Consulta de resultados ejecutada con éxito. Procesando datos...")
	print(results)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://registro.tscn")
