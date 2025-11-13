extends Label

var base_font_size: int
var parent_node: Control
var base_parent_height: float

func _ready() -> void:
	parent_node = get_parent() as Control
	base_font_size = self.get_theme_font_size("font_size")
	base_parent_height = parent_node.size.y

	parent_node.resized.connect(update_font_size)


func update_font_size() -> void:
	var current_container_height: float = parent_node.size.y
	var scale_factor: float = current_container_height / base_parent_height
	var new_font_size: int = int(base_font_size * scale_factor)

	self.add_theme_font_size_override("font_size", new_font_size)
