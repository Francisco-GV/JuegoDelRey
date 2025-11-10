extends Control

@export var character_assets: Array[Texture]

signal character_selected(character_texture: Texture)

var current_index: int = 0

@onready var left_arrow: TextureButton = $LeftArrow
@onready var right_arrow: TextureButton = $RightArrow
@onready var character_display: TextureRect = $CharacterContainer/CharacterDisplay


func _ready() -> void:
	left_arrow.pressed.connect(on_left_arrow_pressed)
	right_arrow.pressed.connect(on_right_arrow_pressed)

	update_display()


func update_display():
	if character_assets.is_empty():
		return

	character_display.texture = character_assets[current_index]

	emit_signal("character_selected", character_assets[current_index])


func on_left_arrow_pressed():
	if character_assets.is_empty():
		return

	current_index -= 1

	if current_index < 0:
		current_index = character_assets.size() - 1

	update_display()


func on_right_arrow_pressed():
	if character_assets.is_empty():
		return

	current_index += 1

	if current_index >= character_assets.size():
		current_index = 0

	update_display()
