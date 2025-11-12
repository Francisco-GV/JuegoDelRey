extends Node

const RUTA_BD: String = "user://juego_del_rey.db"
var db: SQLite


func _ready() -> void:
	db = SQLite.new()
	db.path = RUTA_BD
	db.foreign_keys = true
	var sucess_db: bool = db.open_db()

	if not sucess_db:
		print("Error: No se pudo abrir la base de datos.")
		return

	var table_jugador_monedas: Dictionary = {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"rey": {"data_type": "int"},
		"madre": {"data_type": "int"},
		"anciano": {"data_type": "int"},
		"nino_pobre": {"data_type": "int"},
		"mujer_trabajadora": {"data_type": "int"},
		"joven": {"data_type": "int"},
		"nino_discapacitado": {"data_type": "int"},
		"perro": {"data_type": "int"},
	}

	var table_jugador: Dictionary = {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"nombre": {"data_type": "text"},
		"edad": {"data_type": "int"},
		"genero": {"data_type": "text"},
		"imagen": {"data_type": "text"},
		"id_monedas": {"data_type": "int", "foreign_key": "jugador_monedas.id"},
	}

	var table_partidas: Dictionary = {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true},
		"fecha_guardado": {"data_type": "int"}, # Timestamp
		"id_jugador": {"data_type": "int", "foreign_key": "jugador.id"},
	}

	var success_jugador_monedas = db.create_table("jugador_monedas", table_jugador_monedas)
	var success_jugador = db.create_table("jugador", table_jugador)
	var success_partida = db.create_table("partida", table_partidas)

	if not success_jugador_monedas or not success_jugador or not success_partida:
		print("Error: No se pudieron crear las tablas de la base de datos.")
		print("Tabla Jugador: %s" % success_jugador)
		print("Tabla Jugador Monedas: %s" % success_jugador_monedas)
		print("Tabla Partida: %s" % success_partida)
		return

	print("Base de datos inicializada correctamente en %s" % RUTA_BD)


func guardar_partida(dinero_rey: int, datos_reparto: Dictionary) -> void:
	if db == null:
		print("Error: La base de datos no ha sido inicializada.")
		return

	var datos_monedas: Dictionary = {
		"rey": dinero_rey,
		"madre": datos_reparto["Madre"],
		"anciano": datos_reparto["Anciano"],
		"nino_pobre": datos_reparto["NinoPobre"],
		"mujer_trabajadora": datos_reparto["MujerTrabajadora"],
		"joven": datos_reparto["Joven"],
		"nino_discapacitado": datos_reparto["NinoDiscapacitado"],
		"perro": datos_reparto["Perro"],
	}

	var sucess_jugador_monedas: bool = db.insert_row("jugador_monedas", datos_monedas)

	if not sucess_jugador_monedas:
		print("Error: No se pudieron guardar los datos de monedas.")
		return

	var datos_jugador: Dictionary = {
		"nombre": GameData.player_name,
		"edad": GameData.player_age,
		"genero": GameData.player_gender,
		"imagen": GameData.player_character_path,
		"id_monedas": db.last_insert_rowid,
	}

	var success_jugador: bool = db.insert_row("jugador", datos_jugador)

	if not success_jugador:
		print("Error: No se pudieron guardar los datos del jugador.")
		return

	var datos_partida: Dictionary = {
		"fecha_guardado": int(Time.get_unix_time_from_system()),
		"id_jugador": db.last_insert_rowid,
	}

	var success_partida: bool = db.insert_row("partida", datos_partida)

	if not success_partida:
		print("Error: No se pudieron guardar los datos de la partida.")
		return

	print("Partida guardada exitosamente.")
