extends Control

# Botões de níveis
var level_buttons = []
var last_completed_level_from_game_data: int = 0 

@onready var transition: CanvasLayer = $transition

# Texturas para estrelas (configure no Inspector)
@export var star_texture: Texture2D
@export var gray_star_texture: Texture2D

# Dicionário que guarda as referências das estrelas de cada botão
# Exemplo: {1: [star1, star2, star3], 2: [...], ...}
var level_star_icons := {}

func _ready():
	# Carrega progresso do GameData
	last_completed_level_from_game_data = GameData.last_completed_level

	transition.visible = false
	
	# Lista de botões (adicione todos os que tiver)
	level_buttons = [
		$VBoxContainer/GridContainer/VBoxContainer/Button,
		$VBoxContainer/GridContainer/VBoxContainer2/Button,
		$VBoxContainer/GridContainer/VBoxContainer3/Button,
		$VBoxContainer/GridContainer/VBoxContainer4/Button,
		$VBoxContainer/GridContainer/VBoxContainer5/Button,
		$VBoxContainer/GridContainer/VBoxContainer6/Button,
		$VBoxContainer/GridContainer/VBoxContainer7/Button,
		$VBoxContainer/GridContainer/VBoxContainer8/Button
	]
	
	# Configura cada botão com base no progresso
	for i in range(level_buttons.size()):
		var button = level_buttons[i]
		var level_number = i + 1
		button.text = "Level %d" % level_number
		
		# Pega o overlay de estrelas
		var overlay = button.get_node("star_overlay") if button.has_node("star_overlay") else null

		if overlay and overlay.has_node("HBoxContainer"):
			var star_nodes = [
				overlay.get_node("HBoxContainer/Star"),
				overlay.get_node("HBoxContainer/Star2"),
				overlay.get_node("HBoxContainer/Star3")
			]
			level_star_icons[level_number] = star_nodes
			# Atualiza estrelas conforme recorde salvo
			_atualizar_estrelas_do_nivel(level_number)
		
			# Começa invisível para mostrar só no mouse
			if level_number <= last_completed_level_from_game_data + 1:
				overlay.visible = false
				button.connect("mouse_entered", _on_button_mouse_entered.bind(overlay))
				button.connect("mouse_exited", _on_button_mouse_exited.bind(overlay))
			else:
				# Nível bloqueado → overlay sempre visível
				overlay.visible = true

		# Bloqueio/desbloqueio de botões
		if level_number > last_completed_level_from_game_data + 1:
			button.disabled = true
		else:
			button.connect("pressed", _on_level_button_pressed.bind(level_number))

func _atualizar_estrelas_do_nivel(level_number: int):
	var recorde = GameData.level_stars.get(level_number, 0) # recorde salvo ou 0
	if level_star_icons.has(level_number):
		var icons = level_star_icons[level_number]
		for i in range(icons.size()):
			if i < recorde:
				icons[i].texture = star_texture
			else:
				icons[i].texture = gray_star_texture

func _on_button_mouse_entered(overlay: Control) -> void:
	overlay.visible = true

func _on_button_mouse_exited(overlay: Control) -> void:
	overlay.visible = false

func _on_level_button_pressed(level_number: int):
	transition.change_scene("level_%d" % level_number)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed('ui_cancel'):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
