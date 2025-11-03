extends Node3D

const Moneda = preload("res://scenes/moneda.tscn")

@export var dinero_rey: int = 20
@onready var etiqueta_contador: Label = $UI/Control/ContadorDinero
@onready var camara: Camera3D = $Camera3D

var roles: Dictionary[String, Rol]

# Sprites 3D
@onready var rol_madre: Sprite3D = $RolMadre
@onready var rol_anciano: Sprite3D = $RolAnciano
@onready var rol_nino_pobre: Sprite3D = $RolNinoPobre
@onready var rol_mujer_trabajadora: Sprite3D = $RolMujerTrabajadora
@onready var rol_joven: Sprite3D = $RolJoven
@onready var rol_nino_discapacitado: Sprite3D = $RolNinoDiscapacitado
@onready var rol_perro: Sprite3D = $RolPerro

# Botones
@onready var btn_madre: Button = $UI/Control/BtnMadre
@onready var btn_anciano: Button = $UI/Control/BtnAnciano
@onready var btn_nino_pobre: Button = $UI/Control/BtnNinoPobre
@onready var btn_mujer_trabajadora: Button = $UI/Control/BtnMujerTrabajadora
@onready var btn_joven: Button = $UI/Control/BtnJoven
@onready var btn_nino_discapacitado: Button = $UI/Control/BtnNinoDiscapacitado
@onready var btn_perro: Button = $UI/Control/BtnPerro

enum Posicion { ARRIBA, ABAJO }


func _ready() -> void:
	roles = {
		"Madre": Rol.new(rol_madre, btn_madre),
		"Anciano": Rol.new(rol_anciano, btn_anciano),
		"NinoPobre": Rol.new(rol_nino_pobre, btn_nino_pobre),
		"MujerTrabajadora": Rol.new(rol_mujer_trabajadora, btn_mujer_trabajadora),
		"Joven": Rol.new(rol_joven, btn_joven),
		"NinoDiscapacitado": Rol.new(rol_nino_discapacitado, btn_nino_discapacitado),
		"Perro": Rol.new(rol_perro, btn_perro),
	}

	actualizar_etiqueta_dinero()


func _process(_delta: float) -> void:
	actualizar_posicion_boton(rol_madre, btn_madre)
	actualizar_posicion_boton(rol_anciano, btn_anciano)
	actualizar_posicion_boton(rol_nino_pobre, btn_nino_pobre)
	actualizar_posicion_boton(rol_mujer_trabajadora, btn_mujer_trabajadora)
	actualizar_posicion_boton(rol_joven, btn_joven)
	actualizar_posicion_boton(rol_nino_discapacitado, btn_nino_discapacitado)
	actualizar_posicion_boton(rol_perro, btn_perro)


func actualizar_etiqueta_dinero() -> void:
	etiqueta_contador.text = "Dinero Restante: " + str(dinero_rey)


func actualizar_posicion_boton(personaje: Sprite3D, boton: Button, posicion: Posicion = Posicion.ARRIBA) -> void:
	if posicion == Posicion.ARRIBA:
		_posicionar_boton_sobre_sprite(personaje, boton)
	elif posicion == Posicion.ABAJO:
		_posicionar_boton_debajo_sprite(personaje, boton)


func _posicionar_boton_debajo_sprite(personaje: Sprite3D, boton: Button) -> void:
	var personaje_origin: Vector3 = personaje.global_transform.origin
	var pos_pantalla_2d: Vector2 = camara.unproject_position(personaje_origin)

	var pos_final_x: float = pos_pantalla_2d.x - (boton.size.x / 2.0)
	var pos_final_y: float = boton.position.y

	boton.global_position = Vector2(pos_final_x, pos_final_y)


func _posicionar_boton_sobre_sprite(personaje: Sprite3D, boton: Button) -> void:
	var offset_y: float = 0.0

	if personaje.texture:
		var altura_textura: float = personaje.texture.get_height()
		var pixel_size: float = personaje.pixel_size
		var escala_y: float = personaje.scale.y

		offset_y = (altura_textura * pixel_size / 2.0) * escala_y

	var offset_cabeza := Vector3(0, offset_y, 0)
	var pos_cabeza_3d: Vector3 = personaje.global_transform.origin + offset_cabeza
	var pos_pantalla_2d: Vector2 = camara.unproject_position(pos_cabeza_3d)

	var margen_vertical: float = 5.0
	var pos_final_x: float = pos_pantalla_2d.x - (boton.size.x / 2.0)
	var pos_final_y: float = pos_pantalla_2d.y - boton.size.y - margen_vertical

	boton.global_position = Vector2(pos_final_x, pos_final_y)


func repartir_dinero(rol_id: String) -> void:
	if dinero_rey >= 1:
		dinero_rey -= 1

		roles[rol_id].dinero += 1

		actualizar_etiqueta_dinero()

		var nueva_moneda = Moneda.instantiate()
		var sprite: Sprite3D = roles[rol_id].sprite

		if sprite:
			var pos_personaje = sprite.global_position
			var pos_aparicion = pos_personaje + Vector3(0, 3, 1.75)

			pos_aparicion.x += randf_range(-0.5, 0.5)
			pos_aparicion.z += randf_range(-0.5, 0.5)

			nueva_moneda.global_position = pos_aparicion
			add_child(nueva_moneda)


		print("Se ha dado 1 moneda a %s. Dinero Restante: %s" % [rol_id, dinero_rey])
	else:
		print("No hay más dinero para repartir!")


func reiniciar_juego() -> void:
	get_tree().reload_current_scene()


func _on_btn_confirmar_pressed() -> void:
	print("--- Turno Finalizado ---")
	print("El Rey decidió quedarse con: %d" % dinero_rey)
	print("El reparto final fue:")

	var dinero_repartido: Dictionary = {}

	for rol in roles:
		dinero_repartido[rol] = roles[rol].dinero

	print(dinero_repartido)

	DB.guardar_partida(dinero_rey, dinero_repartido)

	reiniciar_juego()
