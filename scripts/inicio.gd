extends Node3D

var camara_rotacion_base: Vector3
@export var sensibilidad_mouse_camara: float = 0.05
@export var suavizado_mouse_camara: float = 5.0

@onready var canvas_layer_inicio: CanvasLayer = $CanvasLayerInicio
@onready var camara: Camera3D = $Camera3D

const Registro = preload("res://registro.tscn")


func _ready() -> void:
	if camara:
		camara_rotacion_base = camara.rotation

	if GameData.mostrar_escena_registro:
		mostrar_menu_registro()


func _process(delta: float) -> void:
	if camara:
		var tamano_viewport = get_viewport().size
		var pos_mouse = get_viewport().get_mouse_position()
		var centro_viewport = tamano_viewport / 2.0

		var dir_center: Vector3 = camara.project_ray_normal(centro_viewport)
		var dir_mouse: Vector3 = camara.project_ray_normal(pos_mouse)

		var yaw_center = atan2(dir_center.x, dir_center.z)
		var yaw_mouse = atan2(dir_mouse.x, dir_mouse.z)
		var yaw_delta = wrapf(yaw_mouse - yaw_center, -PI, PI)

		var pitch_center = asin(clamp(dir_center.y, -1.0, 1.0))
		var pitch_mouse = asin(clamp(dir_mouse.y, -1.0, 1.0))
		var pitch_delta = pitch_mouse - pitch_center

		var rot_objetivo = Vector3(
			camara_rotacion_base.x - (pitch_delta * sensibilidad_mouse_camara),
			camara_rotacion_base.y + (yaw_delta * sensibilidad_mouse_camara),
			camara_rotacion_base.z,
		)

		camara.rotation = camara.rotation.lerp(rot_objetivo, clamp(suavizado_mouse_camara * delta, 0.0, 1.0))


func _on_btn_iniciar_pressed() -> void:
	mostrar_menu_registro()


func _on_btn_salir_pressed() -> void:
	get_tree().quit()


func mostrar_menu_registro() -> void:
	canvas_layer_inicio.hide()

	var menu_registro = Registro.instantiate()

	add_child(menu_registro)
