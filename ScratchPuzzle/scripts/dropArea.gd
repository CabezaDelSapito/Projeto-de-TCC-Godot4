extends PanelContainer

@onready var target_node = find_child("GridContainer")

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true  # Pode modificar conforme necessário

func _drop_data(at_position: Vector2, data: Variant) -> void:
	# Acha o nó desejado onde o filho deve ser adicionado
	

	
	# Remove o filho atual do nó original
	data[0].get_parent().remove_child(data[0])
	
	# Adiciona o filho no nó desejado
	target_node.add_child(data[0])
	
	# Ajusta a posição global do filho
	data[0].global_position = global_position
