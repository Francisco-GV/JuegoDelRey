extends Sprite3D

var king_shadow_relative_pos := Vector3(0, -3.7, 0)


func _process(_delta: float) -> void:
	var king_pos: Vector3 = get_parent().global_position

	global_position = king_pos + king_shadow_relative_pos


