extends GridContainer


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	data[0].get_parent().remove_child(data[0])
	add_child(data[0])
	data[0].global_position = global_position

