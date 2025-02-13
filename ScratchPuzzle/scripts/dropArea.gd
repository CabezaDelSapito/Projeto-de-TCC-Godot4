extends PanelContainer

@onready var target_node = find_child("GridContainer")
#@onready var map_o1 = get_tree().current_scene.get_node_or_null("MarginContainer/HBoxContainer/LevelMenu/MarginContainer/LevelArea/map_01")
#@onready var player = map_o1.get_node_or_null("player") if map_o1 else null

@onready var level_area = get_tree().current_scene.get_node("MarginContainer/HBoxContainer/LevelMenu/MarginContainer/LevelArea")
@onready var map = level_area.get_child(0) if level_area.get_child_count() > 0 else null
@onready var player = map.get_node_or_null("player") if map else null



func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true  # Pode modificar conforme necessário

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# Acha o nó desejado onde o filho deve ser adicionado
	
	# Remove o filho atual do nó original
	data[0].get_parent().remove_child(data[0])
	
	# Adiciona o filho no nó desejado
	target_node.add_child(data[0])
	
	# Ajusta a posição global do filho
	data[0].global_position = global_position


func _on_execute_button_pressed() -> void:
	var comandos = []
	
	# Obtém todos os filhos do GridContainer e adiciona à lista de comandos
	for child in target_node.get_children():
		if child is TextureRect:
			#print("Comando:", child.name, " | Tipo:", child.CommandType)  # Acessando CommandType
			comandos.append(child)
	
	await executar_sequencial(comandos)


func executar_sequencial(comandos):
	for comando in comandos:
		match comando.name:
			"Andar":
				player.andar()
			"Virar":
				player.virar()
			"Pular":
				player.pular()
			"Parar":
				player.parar()
				
				
		await get_tree().create_timer(0.5).timeout  # Espera entre comandos
