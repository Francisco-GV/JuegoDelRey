extends Node3D

@export var dinero_rey: int = 20
@onready var etiqueta_contador: Label = $UI/Control/ContadorDinero
@onready var camara: Camera3D = $Camera3D

# Sprites 3D
@onready var rol_madre: Sprite3D = $RolMadre

# Botones
@onready var btn_madre: Button = $UI/Control/BtnMadre


func _ready() -> void:
	actualizar_etiqueta_dinero()


func _process(_delta: float) -> void:
	actualizar_posicion_boton(rol_madre, btn_madre)


func actualizar_etiqueta_dinero() -> void:
	etiqueta_contador.text = "Dinero Restante: " + str(dinero_rey)


func actualizar_posicion_boton(personaje: Sprite3D, boton: Button) -> void:
	var offset_y: float = 0.0

	if personaje.texture:
		var altura_textura: float = personaje.texture.get_height()
		var pixel_size: float = personaje.pixel_size
		var escala_y: float = personaje.scale.y

		offset_y = (altura_textura * pixel_size / 2.0) * escala_y
		offset_y += 0.5

	var offset_cabeza := Vector3(0, offset_y, 0)
	var pos_cabeza_3d: Vector3 = personaje.global_transform.origin + offset_cabeza
	var pos_pantalla_2d: Vector2 = camara.unproject_position(pos_cabeza_3d)

	boton.global_position = pos_pantalla_2d - (boton.size / 2.0)


func _on_btn_madre_pressed() -> void:
	if dinero_rey >= 1:
		dinero_rey -= 1

		actualizar_etiqueta_dinero()

		print("Se ha dado 1 moneda a madre. Dinero Restante: " + str(dinero_rey))
	else:
		print("No hay más dinero para repartir!")
