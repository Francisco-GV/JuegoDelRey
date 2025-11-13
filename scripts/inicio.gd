extends Node3D

@onready var canvas_layer_inicio: CanvasLayer = $CanvasLayerInicio

const Registro = preload("res://registro.tscn")


func _on_btn_iniciar_pressed() -> void:
	canvas_layer_inicio.hide()

	var menu_registro = Registro.instantiate()

	add_child(menu_registro)


func _on_btn_salir_pressed() -> void:
	get_tree().quit()
