extends CanvasLayer

@export var gender_group: ButtonGroup

@onready var txt_nombre: LineEdit = $Scale1/Left/VBoxContainer/TxtNombre
@onready var txt_edad: SpinBox = $Scale1/Left/VBoxContainer/TxtEdad

@onready var selector: HFlowContainer = $Scale1/Left/VBoxContainer/GenderSelector
@onready var btn_continuar: Button = $Scale1/Right/VBoxContainer/BtnContinuar

var selected_gender: String = "Hombre"
var selected_character: Texture

func _ready() -> void:
	await get_tree().process_frame

	for child in selector.get_children():
		if child is BaseButton:
			child.toggle_mode = true
			child.button_group = gender_group

			child.pressed.connect(_on_gender_selected.bind(child))


func _on_gender_selected(button_pressed: BaseButton) -> void:
	# Realmente tienen que ser de tipo GenderButton
	selected_gender = button_pressed.gender_value


func _on_btn_continuar_pressed():
	var nombre: String = txt_nombre.text.strip_edges()

	if nombre.is_empty():
		return

	var edad := int(txt_edad.value)
	var genero: String = selected_gender
	var _textura: Texture = selected_character

	print("nombre:", nombre)
	print("edad:", edad)
	print("género:", genero)


func _on_character_selector_character_selected(character_texture: Texture) -> void:
	selected_character = character_texture
