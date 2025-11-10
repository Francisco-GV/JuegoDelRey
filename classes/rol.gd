class_name Rol
extends Resource

var sprite: Sprite3D
var controles: Container
var contador: Label3D
var dinero: int = 0
var monedas: Array[RigidBody3D] = []

func _init(rol_sprite: Sprite3D, rol_controles: Container, rol_contador: Label3D) -> void:
    self.sprite = rol_sprite
    self.controles = rol_controles
    self.contador = rol_contador
