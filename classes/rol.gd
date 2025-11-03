class_name Rol
extends Resource

var sprite: Sprite3D
var controles: Container
var dinero: int = 0

func _init(rol_sprite: Sprite3D, rol_controles: Container) -> void:
    self.sprite = rol_sprite
    self.controles = rol_controles
