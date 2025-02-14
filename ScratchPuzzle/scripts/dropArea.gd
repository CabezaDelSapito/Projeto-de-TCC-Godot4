extends PanelContainer

@onready var target_node = find_child("GridContainer")

@onready var level_area = get_tree().current_scene.get_node("MarginContainer/HBoxContainer/LevelMenu/MarginContainer/LevelArea")
@onready var map = level_area.get_child(0) if level_area.get_child_count() > 0 else null
@onready var player = map.get_node_or_null("player") if map else null



func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true  # Pode modificar conforme necessário

func _drop_data(at_position: Vector2, data: Variant) -> void:
	# Verifica se a posição mudou antes de adicionar o filho ao nó
	if data[0].get_parent() != target_node:
		target_node.add_child(data[0].duplicate())
	

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
		match comando.CommandType:
			0:
				player.andar()
			1:
				player.virar()
			2:
				player.pular()
				
				
		await get_tree().create_timer(0.6).timeout  # Espera entre comandos
