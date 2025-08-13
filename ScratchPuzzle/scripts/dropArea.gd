extends PanelContainer

@onready var target_node = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var level_area: Node = $"../../LevelArea"
var map: Node = null
var player: Node = null
var goal: Area2D = null
@onready var execute_button = $MarginContainer/VBoxContainer/HBoxContainer/ExecuteButton

func _ready():
	await get_tree().process_frame
	find_map_and_player()

func find_map_and_player():
	if level_area and level_area.get_child_count() > 0:
		map = level_area.get_child(0)
	
	if map:
		player = map.find_child("player", true, false)
	
	if not player:
		print("⚠️ Player não encontrado no mapa!")

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data[0].get_parent() != target_node:
		target_node.add_child(data[0].duplicate())

func _on_execute_button_pressed() -> void:
	# Desabilita o botão de executar
	execute_button.disabled = true
	
	var comandos = []
	for child in target_node.get_children():
		if child is TextureRect:
			var tempo = child.get_valor() if child.has_method("get_valor") else 1.0
			comandos.append([child, tempo])
		elif child.CommandType == 5:  # "Repetir"
			var repeat_count = child.get_repeat_count()
			var inner_comandos = child.get_comandos()
			comandos.append([child, repeat_count, inner_comandos])
		elif child.CommandType == 6:  # "Se"
			var condition_data = child.get_condition()
			comandos.append([child, condition_data])
	
	await executar_sequencial(comandos)

func executar_sequencial(comandos):
	find_map_and_player()
	
	if not player:
		print("⚠️ Nenhum player encontrado para executar os comandos.")
		return
	
	for comando_data in comandos:
		var comando = comando_data[0]

		match comando.CommandType:
			0:  # Andar
				player.andar()
			1:  # Virar
				player.virar()
			2:  # Pular
				player.pular()
			3:  # Parar
				player.parar()
			4:  # Esperar
				var tempo = comando_data[1]
				await player.esperar(tempo)
			5:  # Repetir
				var repeat_count = comando.get_repeat_count()
				var inner_comandos = comando.get_comandos()
				for _i in range(repeat_count):
					await executar_sequencial(inner_comandos)
			6:  # Se (novo comando)
				var condition = comando.get_condition()
				var inner_comandos = comando.get_comandos()

				# Espera até a condição ser verdadeira
				while player and is_instance_valid(player) and not player.check_condition(condition):
					await get_tree().process_frame

				if not player or not is_instance_valid(player):
					return

				# Executa os comandos internos
				await executar_sequencial(inner_comandos)

				# Espera até a condição voltar a ser falsa
				while player and is_instance_valid(player) and player.check_condition(condition):
					await get_tree().process_frame


