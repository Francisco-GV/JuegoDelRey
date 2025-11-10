extends CanvasLayer

@export var gender_group: ButtonGroup

@onready var selector: HFlowContainer = $Scale1/Left/VBoxContainer/GenderSelector

func _ready() -> void:
	await get_tree().process_frame

	for child in selector.get_children():
		if child is BaseButton:
			child.toggle_mode = true
			child.button_group = gender_group

			child.pressed.connect(_on_gender_selected.bind(child))


func _on_gender_selected(button_pressed: BaseButton) -> void:
	# Realmente tienen que ser de tipo GenderButton
	print("Se presionó el botón: ", button_pressed.gender_value)
	pass
