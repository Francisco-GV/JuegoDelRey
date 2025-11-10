extends Node3D

const Moneda = preload("res://scenes/moneda.tscn")
const Spark = preload("res://scenes/effects/spark.tscn")
const Poof = preload("res://scenes/effects/poof.tscn")

@export var dinero_rey: int = 20
@onready var etiqueta_contador: Label = $UI/Control/ContadorDinero
@onready var camara: Camera3D = $Camera3D

var camara_rotacion_base: Vector3
@export var sensibilidad_mouse_camara: float = 0.05
@export var suavizado_mouse_camara: float = 5.0

var roles: Dictionary[String, Rol]

# Sprites 3D
@onready var rey: Sprite3D = $Rey
@onready var rol_madre: Sprite3D = $RolMadre
@onready var rol_anciano: Sprite3D = $RolAnciano
@onready var rol_nino_pobre: Sprite3D = $RolNinoPobre
@onready var rol_mujer_trabajadora: Sprite3D = $RolMujerTrabajadora
@onready var rol_joven: Sprite3D = $RolJoven
@onready var rol_nino_discapacitado: Sprite3D = $RolNinoDiscapacitado
@onready var rol_perro: Sprite3D = $RolPerro

# Botones
@onready var ctrl_madre: Container = $UI/Control/CtrlMadre
@onready var ctrl_anciano: Container = $UI/Control/CtrlAnciano
@onready var ctrl_nino_pobre: Container = $UI/Control/CtrlNinoPobre
@onready var ctrl_mujer_trabajadora: Container = $UI/Control/CtrlMujerTrabajadora
@onready var ctrl_joven: Container = $UI/Control/CtrlJoven
@onready var ctrl_nino_discapacitado: Container = $UI/Control/CtrlNinoDiscapacitado
@onready var ctrl_perro: Container = $UI/Control/CtrlPerro

# Contadores
@onready var counter_madre: Label3D = $RolMadre/Bowl/Counter
@onready var counter_anciano: Label3D = $RolAnciano/Bowl/Counter
@onready var counter_nino_pobre: Label3D = $RolNinoPobre/Bowl/Counter
@onready var counter_mujer_trabajadora: Label3D = $RolMujerTrabajadora/Bowl/Counter
@onready var counter_joven: Label3D = $RolJoven/Bowl/Counter
@onready var counter_nino_discapacitado: Label3D = $RolNinoDiscapacitado/Bowl/Counter
@onready var counter_perro: Label3D = $RolPerro/Bowl/Counter

enum Posicion { ARRIBA, ABAJO }


func _ready() -> void:
	if camara:
		camara_rotacion_base = camara.rotation

	inicializar_rey()

	roles = {
		"Madre": Rol.new(rol_madre, ctrl_madre, counter_madre),
		"Anciano": Rol.new(rol_anciano, ctrl_anciano, counter_anciano),
		"NinoPobre": Rol.new(rol_nino_pobre, ctrl_nino_pobre, counter_nino_pobre),
		"MujerTrabajadora": Rol.new(rol_mujer_trabajadora, ctrl_mujer_trabajadora, counter_mujer_trabajadora),
		"Joven": Rol.new(rol_joven, ctrl_joven, counter_joven),
		"NinoDiscapacitado": Rol.new(rol_nino_discapacitado, ctrl_nino_discapacitado, counter_nino_discapacitado),
		"Perro": Rol.new(rol_perro, ctrl_perro, counter_perro),
	}

	actualizar_etiqueta_dinero()


func _process(delta: float) -> void:
	actualizar_posicion_controles(rol_madre, ctrl_madre)
	actualizar_posicion_controles(rol_anciano, ctrl_anciano)
	actualizar_posicion_controles(rol_nino_pobre, ctrl_nino_pobre)
	actualizar_posicion_controles(rol_mujer_trabajadora, ctrl_mujer_trabajadora)
	actualizar_posicion_controles(rol_joven, ctrl_joven)
	actualizar_posicion_controles(rol_nino_discapacitado, ctrl_nino_discapacitado)
	actualizar_posicion_controles(rol_perro, ctrl_perro)


	if camara:
		var tamano_viewport = get_viewport().size
		var pos_mouse = get_viewport().get_mouse_position()

		var centro_viewport = tamano_viewport / 2.0

		var offset_mouse_normalizado = (pos_mouse - centro_viewport) / centro_viewport

		var rot_objetivo = Vector3(
			camara_rotacion_base.x - (offset_mouse_normalizado.y * sensibilidad_mouse_camara),
			camara_rotacion_base.y - (offset_mouse_normalizado.x * sensibilidad_mouse_camara),
			camara_rotacion_base.z
		)

		camara.rotation = camara.rotation.lerp(rot_objetivo, suavizado_mouse_camara * delta)


func inicializar_rey() -> void:
	var character_path = GameData.player_character_path
	if character_path.is_empty():
		print("Error: no se encontró GameData.player_character_path.")
		character_path = "res://assets/images/reyes/Hombre/rey_1.png"

	var selected_texture: Texture2D = load(character_path)

	rey.texture = selected_texture
	rey.material_override.set_shader_parameter("u_sprite_texture", selected_texture)


func actualizar_etiqueta_dinero() -> void:
	etiqueta_contador.text = "Dinero Restante: " + str(dinero_rey)

	actualizar_label_3D()


func actualizar_label_3D() -> void:
	for rol in roles:
		roles[rol].contador.text = str(roles[rol].dinero)


func actualizar_posicion_controles(personaje: Sprite3D, controles: Container, posicion: Posicion = Posicion.ARRIBA) -> void:
	if posicion == Posicion.ARRIBA:
		_posicionar_controles_sobre_sprite(personaje, controles)
	elif posicion == Posicion.ABAJO:
		_posicionar_controles_debajo_sprite(personaje, controles)


func _posicionar_controles_debajo_sprite(personaje: Sprite3D, controles: Container) -> void:
	var personaje_origin: Vector3 = personaje.global_transform.origin
	var pos_pantalla_2d: Vector2 = camara.unproject_position(personaje_origin)

	var pos_final_x: float = pos_pantalla_2d.x - (controles.size.x / 2.0)
	var pos_final_y: float = controles.position.y

	controles.global_position = Vector2(pos_final_x, pos_final_y)


func _posicionar_controles_sobre_sprite(personaje: Sprite3D, controles: Container) -> void:
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
	var pos_final_x: float = pos_pantalla_2d.x - (controles.size.x / 2.0)
	var pos_final_y: float = pos_pantalla_2d.y - controles.size.y - margen_vertical

	controles.global_position = Vector2(pos_final_x, pos_final_y)


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

			add_child(nueva_moneda)
			nueva_moneda.global_position = pos_aparicion

			roles[rol_id].monedas.push_back(nueva_moneda)

			var spark: GPUParticles3D = Spark.instantiate()
			add_child(spark)
			spark.global_position = pos_aparicion
			spark.emitting = true


		print("Se ha dado 1 moneda a %s. Dinero Restante: %s" % [rol_id, dinero_rey])
	else:
		print("No hay más dinero para repartir!")


func remover_dinero(rol_id: String) -> void:
	if roles[rol_id].dinero > 0:
		dinero_rey += 1

		roles[rol_id].dinero -= 1

		actualizar_etiqueta_dinero()

		var moneda = roles[rol_id].monedas.pick_random()
		var pos_moneda = moneda.global_position

		remove_child(moneda)
		roles[rol_id].monedas.erase(moneda)

		var poof: GPUParticles3D = Poof.instantiate()
		add_child(poof)
		poof.global_position = pos_moneda
		poof.emitting = true

		print("Se ha quitado 1 moneda a %s. Dinero Restante: %s" % [rol_id, dinero_rey])
	else:
		print("No hay más dinero que quitar a %s!" % rol_id)


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
