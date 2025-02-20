extends VBoxContainer


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	#if data[1] == CommandType:
		return true
	#return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#data[0].get_parent().remove_child(data[0])
	# Adiciona o filho no nó desejado
	add_child(data[0].duplicate())
	#data[0].global_position = global_position

