extends MarginContainer

@onready var target_node = find_child("VBoxContainer")

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data[0].get_parent() != target_node:
		target_node.add_child(data[0].duplicate())
	else:
		data[0].get_parent().remove_child(data[0])
