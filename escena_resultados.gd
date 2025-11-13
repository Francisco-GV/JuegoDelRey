extends Control

@export var character_bar_scene: PackedScene
@export var coin_texture: Texture2D

@onready var graph_container = $BarChart/GraphContainer

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
	WHERE p.id = ?
    """

	var success: bool = DB.db.query_with_bindings(query, [DB.db.last_insert_rowid])

	if not success:
		print("Error: No se pudo ejecutar la consulta para obtener los resultados.")
		return

	var ultima_partida = DB.db.query_result

	print("Consulta de última partida ejecutada con éxito. Procesando datos...")
	print(ultima_partida)

	if ultima_partida.size() > 0:
		var datos_partida: Dictionary = ultima_partida[0]

		var datos_grafica: Dictionary = {
			"rey": datos_partida["monedas_rey"],
			"madre": datos_partida["monedas_madre"],
			"anciano": datos_partida["monedas_anciano"],
			"ninoPobre": datos_partida["monedas_nino_pobre"],
			"mujerTrabajadora": datos_partida["monedas_mujer_trabajadora"],
			"joven": datos_partida["monedas_joven"],
			"ninoDiscapacitado": datos_partida["monedas_nino_discapacitado"],
			"perro": datos_partida["monedas_perro"],
		}

		update_graph(datos_grafica)
	else:
		print("No se encontraron datos de partida.")
		print("Usando datos de prueba para la gráfica.")
		var datos_prueba: Dictionary = obtener_datos_prueba()
		update_graph(datos_prueba)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://registro.tscn")


func update_graph(data: Dictionary):
	# Limpiza de las barras anteriores
	for child in graph_container.get_children():
		child.queue_free()

	for character_name in data:
		var coin_count = data[character_name]

		var bar_instance = character_bar_scene.instantiate()
		bar_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL

		var head_texture_node = bar_instance.get_node("HeadTexture")
		# Carga la textura de la cabeza del personaje,
		# asumiendo que los archivos siguen el patrón "cabeza_<nombre>.png"
		var head_texture_path = "res://assets/images/heads/cabeza_%s.png" % character_name
		var head_texture = load(head_texture_path) as Texture2D
		head_texture_node.texture = head_texture

		head_texture_node.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		head_texture_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		var counter_node = bar_instance.get_node("Counter")

		counter_node.text = str(coin_count)

		var coin_container_node = bar_instance.get_node("CoinContainer")

		# Limpiza de monedas anteriores (Usadas de prueba en la escena)
		for child in coin_container_node.get_children():
			child.queue_free()

		for i in coin_count:
			var coin = TextureRect.new()
			coin.texture = coin_texture
			coin.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			coin.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			coin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			coin_container_node.add_child(coin)

		graph_container.add_child(bar_instance)


func obtener_datos_prueba() -> Dictionary:
	var rng = RandomNumberGenerator.new()
	return {
		"rey": rng.randi_range(1, 10),
		"madre": rng.randi_range(1, 10),
		"anciano": rng.randi_range(1, 10),
		"ninoPobre": rng.randi_range(1, 10),
		"mujerTrabajadora": rng.randi_range(1, 10),
		"joven": rng.randi_range(1, 10),
		"ninoDiscapacitado": rng.randi_range(1, 10),
		"perro": rng.randi_range(1, 10),
	}
