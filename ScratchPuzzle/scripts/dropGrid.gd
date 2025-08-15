extends VBoxContainer

# Variáveis para controle do drag and drop interno
var drop_indicator : ColorRect = null
var is_command_se_container := true

func _ready():
	# Configura o indicador de drop para esta VBoxContainer interna
	setup_drop_indicator()

func setup_drop_indicator():
	if drop_indicator and is_instance_valid(drop_indicator):
		remove_child(drop_indicator)
		drop_indicator.queue_free()
	
	drop_indicator = ColorRect.new()
	drop_indicator.color = Color(0.2, 0.8, 0.2, 0.7)  # Cor diferente para diferenciar
	drop_indicator.size = Vector2(0, 4)
	drop_indicator.visible = false
	add_child(drop_indicator)
	move_child(drop_indicator, get_child_count())  # Coloca no final

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	if get_parent() and get_parent().get_parent() and get_parent().get_parent() is GridContainer:
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var dropped_node = data[0]
	var original_parent = dropped_node.get_parent()
	
	drop_indicator.visible = false
	
	# Se vier da área de comandos disponíveis, duplica
	if original_parent is GridContainer:
		var new_node = dropped_node.duplicate()
		var insert_position = calculate_insert_position(at_position, null)
		add_child(new_node)
		if insert_position < get_child_count() - 1:
			move_child(new_node, insert_position)
	# Se já está nesta VBoxContainer, apenas reordena
	elif original_parent == self:
		var insert_position = calculate_insert_position(at_position, dropped_node)
		remove_child(dropped_node)
		add_child(dropped_node)
		move_child(dropped_node, insert_position)
	# Se vier de outra área de execução, move sem duplicar
	else:
		original_parent.remove_child(dropped_node)
		var insert_position = calculate_insert_position(at_position, null)
		add_child(dropped_node)
		if insert_position < get_child_count() - 1:
			move_child(dropped_node, insert_position)

func calculate_insert_position(_at_position: Vector2, excluded_node: Control) -> int:
	var local_pos = get_local_mouse_position()
	var insert_position = get_child_count()
	
	for i in range(get_child_count()):
		var child = get_child(i)
		if child == excluded_node or child == drop_indicator:
			continue
			
		var child_rect = Rect2(Vector2(0, 0), child.size)
		child_rect.position = child.position
		
		if local_pos.y < child_rect.position.y + child_rect.size.y / 2:
			insert_position = i
			break
	
	return insert_position

func _get_drag_data(at_position: Vector2):
	for child in get_children():
		if child == drop_indicator:
			continue
			
		var rect = Rect2(child.position, child.size)
		if rect.has_point(at_position):
			# Cria preview visual
			var preview = child.duplicate()
			preview.modulate = Color(1, 1, 1, 0.5)
			set_drag_preview(preview)
			
			return [child]
	return null

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if is_instance_valid(drop_indicator):
			drop_indicator.visible = false

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and get_global_rect().has_point(get_global_mouse_position()):
		var local_pos = get_local_mouse_position()
		var insert_pos = calculate_insert_position(local_pos, null)
		
		if is_instance_valid(drop_indicator):
			if insert_pos < get_child_count():
				var reference_child = get_child(insert_pos)
				if reference_child != drop_indicator:
					drop_indicator.size = Vector2(size.x, 4)
					drop_indicator.position = reference_child.position - Vector2(0, 2)
					drop_indicator.visible = true
			else:
				if get_child_count() > 0:
					var last_child = get_child(get_child_count() - 1)
					if last_child != drop_indicator:
						drop_indicator.size = Vector2(size.x, 4)
						drop_indicator.position = last_child.position + Vector2(0, last_child.size.y - 2)
						drop_indicator.visible = true
