class_name Rol
extends Resource

var sprite: Sprite3D
var button: Button
var dinero: int = 0

func _init(rol_sprite: Sprite3D, rol_button: Button) -> void:
    self.sprite = rol_sprite
    self.button = rol_button
