extends Node3D

@export var dinero_rey: int = 20
@onready var etiqueta_contador: Label = $UI/Control/ContadorDinero


func _ready() -> void:
	actualizar_etiqueta_dinero()


func actualizar_etiqueta_dinero() -> void:
	etiqueta_contador.text = "Dinero Restante: " + str(dinero_rey)


func _on_btn_madre_pressed() -> void:
	if dinero_rey >= 1:
		dinero_rey -= 1

		actualizar_etiqueta_dinero()

		print("Se ha dado 1 moneda a madre. Dinero Restante: " + str(dinero_rey))
	else:
		print("No hay más dinero para repartir!")
