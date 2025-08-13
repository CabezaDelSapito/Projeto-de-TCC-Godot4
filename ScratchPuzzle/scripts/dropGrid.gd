extends VBoxContainer


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if get_parent() and get_parent().get_parent() and get_parent().get_parent() is GridContainer:
		return false
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#data[0].get_parent().remove_child(data[0])
	# Adiciona o filho no nó desejado
	add_child(data[0].duplicate())
	#data[0].global_position = global_position
