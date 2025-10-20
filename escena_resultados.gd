extends Control


func _ready() -> void:
	if not DB or DB.db == null:
		print("Error: El gestor de base de datos no está inicializado")
		return

	var datos_obtenidos: Array = DB.db.select_rows("partidas", "1=1", ["*"])

	var roles_columnas: Dictionary = {
		"Madre": "dinero_madre",
		"Anciano": "dinero_anciano",
		"Nino Pobre": "dinero_nino_pobre",
		"Mujer Trabajadora": "dinero_mujer_trabajadora",
		"Joven": "dinero_joven",
		"Nino Discapacitado": "dinero_nino_discapacitado",
		"Perro": "dinero_perro",
	}

	print(" --- Resultados --- ")
	print("Total de partidas jugadas: ", datos_obtenidos.size())

	for partida in datos_obtenidos:
		print("\n\tPartida ID: %d. Rey se quedó con: %d" % [partida["id"], partida["dinero_rey"]])
		for rol in roles_columnas:
			var dinero_reparto: int = partida[roles_columnas[rol]]
			print("\t\tReparto a %s: %d" % [rol, dinero_reparto])
