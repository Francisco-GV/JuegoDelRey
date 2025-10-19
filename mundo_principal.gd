extends Node3D

@export var dinero_rey: int = 20
@onready var etiqueta_contador: Label = $UI/Control/ContadorDinero


func _ready() -> void:
	actualizar_etiqueta_dinero()


func actualizar_etiqueta_dinero() -> void:
	etiqueta_contador.text = "Dinero Restante: " + str(dinero_rey)
