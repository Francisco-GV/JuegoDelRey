@tool
extends TextureButton


@export var icon_texture: Texture:
	set(value):
		icon_texture = value
		_update_icon_texture()

@onready var icon_rect: TextureRect = $IconRect


func _ready() -> void:
	_update_icon_texture()


func _update_icon_texture():
	if icon_rect:
		icon_rect.texture = icon_texture
