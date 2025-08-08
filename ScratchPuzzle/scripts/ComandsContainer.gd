extends PanelContainer

#@export_enum("Andar", "Virar", "Pular") var CommandType = 0
@onready var target_node = $MarginContainer/VBoxContainer/GridContainer

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	#if data[1] == CommandType:
		return true
	#return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data[0].get_parent() != target_node:
		#target_node.add_child(data[0].duplicate())
		data[0].get_parent().remove_child(data[0])
	#add_child(data[0])
	#data[0].global_position = global_position
