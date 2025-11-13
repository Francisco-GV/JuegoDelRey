extends PathFollow3D

@export var speed: float = 50.0
@onready var camara_fija = $"../../CamaraFija"
@onready var camara_movil: Camera3D = $CamaraMovil

var finalizado := false

func _process(delta):
	if finalizado:
		return

	progress += speed * delta

	if progress_ratio >= 1.0:
		progress_ratio = 1.0
		finalizado = true

		global_position = camara_fija.global_position
		global_rotation = camara_fija.global_rotation

		camara_movil.current = false
		camara_fija.current = true

		GameData.intro_activa = false
