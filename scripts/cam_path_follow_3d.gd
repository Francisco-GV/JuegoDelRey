extends PathFollow3D

@export var speed: float = 50.0
@export var ui: CanvasLayer
@onready var camara_fija = $"../../CamaraFija"
@onready var camara_movil: Camera3D = $CamaraMovil

var finalizado := false

func _process(delta):
	if finalizado:
		return

	progress += speed * delta

	if progress_ratio >= 0.95 and not finalizado:
		var t = clamp((progress_ratio - 0.95) / 0.05, 0.0, 1.0)
		global_position = global_position.lerp(camara_fija.global_position, t)
		global_rotation = global_rotation.lerp(camara_fija.global_rotation, t)

	if progress_ratio >= 1.0:
		progress_ratio = 1.0
		finalizado = true

		global_position = camara_fija.global_position
		global_rotation = camara_fija.global_rotation

		camara_movil.current = false
		camara_fija.current = true
		ui.show()

		GameData.intro_activa = false
