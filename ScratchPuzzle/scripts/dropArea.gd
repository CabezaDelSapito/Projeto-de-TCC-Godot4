extends PanelContainer

@onready var target_node = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var level_area: Node = $"../../LevelArea"
var map: Node = null
var player: Node = null
var goal: Area2D = null
@onready var execute_button = $MarginContainer/VBoxContainer/HBoxContainer/ExecuteButton

# Variáveis para controle do drag and drop
var drag_preview : Control = null
var drop_indicator : ColorRect = null
var dragging_node : Control = null
var is_changing_level := false
var is_transitioning := false

func _ready():
	add_to_group("execution_areas")
	await get_tree().process_frame
	find_map_and_player()
	setup_drop_indicator()

func setup_drop_indicator():
	# Remove o indicador antigo se existir
	if drop_indicator and is_instance_valid(drop_indicator):
		target_node.remove_child(drop_indicator)
		drop_indicator.queue_free()
	
	# Cria um novo indicador
	drop_indicator = ColorRect.new()
	drop_indicator.color = Color(1, 1, 1, 0.5)
	drop_indicator.size = Vector2(0, 4)
	drop_indicator.visible = false
	target_node.add_child(drop_indicator)

func find_map_and_player():
	if level_area and level_area.get_child_count() > 0:
		map = level_area.get_child(0)
	
	if map:
		player = map.find_child("player", true, false)
	
	if not player:
		print("⚠️ Player não encontrado no mapa!")

func prepare_for_scene_change():
	is_transitioning = true
	# Limpa a área de forma segura
	safe_clear()

func scene_change_completed():
	is_transitioning = false
	# Reconfigura o sistema de drop
	setup_drop_indicator()

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return not is_transitioning and not is_changing_level

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if is_transitioning or is_changing_level or not is_instance_valid(drop_indicator):
		return
	
	var dropped_node = data[0]
	var original_parent = dropped_node.get_parent()
	
	drop_indicator.visible = false
	
	# Caso 1: Veio da área de comandos (duplica)
	if original_parent == $"../CommandArea/MarginContainer/VBoxContainer/GridContainer":
		var new_node = dropped_node.duplicate()
		var insert_position = calculate_insert_position(at_position, null)
		target_node.add_child(new_node)
		if insert_position < target_node.get_child_count() - 1:
			target_node.move_child(new_node, insert_position)
	
	# Caso 2: Já está na área de execução (reordena)
	elif original_parent == target_node:
		var insert_position = calculate_insert_position(at_position, dropped_node)
		target_node.remove_child(dropped_node)
		target_node.add_child(dropped_node)
		target_node.move_child(dropped_node, insert_position)
	
	# Caso 3: Veio de outro lugar (como o "SE") - move sem duplicar
	else:
		original_parent.remove_child(dropped_node)
		var insert_position = calculate_insert_position(at_position, null)
		target_node.add_child(dropped_node)
		if insert_position < target_node.get_child_count() - 1:
			target_node.move_child(dropped_node, insert_position)

func calculate_insert_position(at_position: Vector2, excluded_node: Control) -> int:
	var local_pos = target_node.get_local_mouse_position()
	var insert_position = target_node.get_child_count()
	
	for i in range(target_node.get_child_count()):
		var child = target_node.get_child(i)
		if child == excluded_node or child == drop_indicator:
			continue
			
		var child_rect = Rect2(Vector2(0, 0), child.size)
		child_rect.position = child.position
		
		# Verifica se a posição está acima do centro do filho atual
		if local_pos.y < child_rect.position.y + child_rect.size.y / 2:
			insert_position = i
			break
	
	return insert_position

func _get_drag_data(at_position: Vector2):
	if is_changing_level:
		return null
		
	# Identifica qual nó está sendo arrastado
	for child in target_node.get_children():
		if child == drop_indicator:
			continue
			
		var rect = Rect2(child.position, child.size)
		if rect.has_point(at_position):
			dragging_node = child
			
			# Cria um preview para feedback visual
			drag_preview = child.duplicate()
			drag_preview.modulate = Color(1, 1, 1, 0.7)
			set_drag_preview(drag_preview)
			
			return [child]
	return null

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		dragging_node = null
		if is_instance_valid(drop_indicator):
			drop_indicator.visible = false

func _process(_delta):
	if is_changing_level:
		return
		
	if dragging_node and drag_preview and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_pos = target_node.get_local_mouse_position()
		var insert_pos = calculate_insert_position(local_pos, dragging_node)
		
		# Atualiza o indicador de drop
		if is_instance_valid(drop_indicator):
			if insert_pos < target_node.get_child_count():
				var reference_child = target_node.get_child(insert_pos)
				if reference_child != drop_indicator:
					drop_indicator.size = Vector2(target_node.size.x, 4)
					drop_indicator.position = reference_child.position - Vector2(0, 2)
					drop_indicator.visible = true
			else:
				var last_child = target_node.get_child(target_node.get_child_count() - 1)
				if last_child != drop_indicator:
					drop_indicator.size = Vector2(target_node.size.x, 4)
					drop_indicator.position = last_child.position + Vector2(0, last_child.size.y - 2)
					drop_indicator.visible = true

func safe_clear():
	is_changing_level = true
	# Limpa todos os comandos
	for child in target_node.get_children():
		child.queue_free()
	is_changing_level = false
	
	# Recria completamente o sistema de drop
	setup_drop_indicator()
	# Garante que o drag and drop será reiniciado
	dragging_node = null
	drag_preview = null

func _on_execute_button_pressed() -> void:
	if is_changing_level:
		return
		
	# Desabilita o botão de executar
	execute_button.disabled = true
	
	# Na função _on_execute_button_pressed, substitua esta parte:
	var comandos = []
	for child in target_node.get_children():
		if child == drop_indicator:
			continue
			
		if child is TextureRect:
			# Verifica se é um bloco de comando válido
			if child.has_method("get_command_type"):
				var command_type = child.get_command_type()
				
				if command_type == 4:  # "Esperar"
					var tempo = child.get_valor() if child.has_method("get_valor") else 1.0
					comandos.append([child, tempo])
				elif command_type == 5:  # "Repetir"
					var repeat_count = child.get_repeat_count()
					var inner_comandos = child.get_comandos()
					comandos.append([child, repeat_count, inner_comandos])
				elif command_type == 6:  # "Se"
					var condition_data = child.get_condition()
					comandos.append([child, condition_data])
				else:  # Comandos simples (Andar, Virar, Pular, Parar)
					comandos.append([child])
	
	await executar_sequencial(comandos)

func executar_sequencial(comandos):
	find_map_and_player()
	
	if not player:
		print("⚠️ Nenhum player encontrado para executar os comandos.")
		return
	
	for comando_data in comandos:
		var comando = comando_data[0]
		
		if not comando or not is_instance_valid(comando):
			continue
			
		if not comando.has_method("get_command_type"):
			continue
			
		var command_type = comando.get_command_type()
		
		match command_type:
			0:  # Andar
				if player.has_method("andar"):
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
