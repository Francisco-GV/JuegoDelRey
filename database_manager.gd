extends Node

const RUTA_BD: String = "user://juego_del_rey.db"
var db: SQLite


func _ready() -> void:
	db = SQLite.new()
	db.path = RUTA_BD
	var success: bool = db.open_db()

	if not success:
		print("Error: No se pudo abrir la base de datos.")
		return

	var table_partidas: Dictionary = {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"dinero_rey": {"data_type": "int"},
		"dinero_madre": {"data_type": "int"},
		"dinero_anciano": {"data_type": "int"},
		"dinero_nino_pobre": {"data_type": "int"},
		"dinero_mujer_trabajadora": {"data_type": "int"},
		"dinero_joven": {"data_type": "int"},
		"dinero_nino_discapacitado": {"data_type": "int"},
		"dinero_perro": {"data_type": "int"},
	}

	success = db.create_table("partidas", table_partidas)

	if not success:
		print("Error: No se pudo crear la tabla 'partidas' en la base de datos.")
		return

	print("Base de datos inicializada correctamente en %s" % RUTA_BD)


func guardar_partida(dinero_rey: int, datos_reparto: Dictionary) -> void:
	if db == null:
		print("Error: La base de datos no ha sido inicializada.")
		return

	var datos: Dictionary = {
		"dinero_rey": dinero_rey,
		"dinero_madre": datos_reparto["Madre"],
		"dinero_anciano": datos_reparto["Anciano"],
		"dinero_nino_pobre": datos_reparto["NinoPobre"],
		"dinero_mujer_trabajadora": datos_reparto["MujerTrabajadora"],
		"dinero_joven": datos_reparto["Joven"],
		"dinero_nino_discapacitado": datos_reparto["NinoDiscapacitado"],
		"dinero_perro": datos_reparto["Perro"],
	}

	var success: bool = db.insert_row("partidas", datos)

	if not success:
		print("Error: No se pudo guardar la partida.")
		return

	print("Partida guardada exitosamente.")
