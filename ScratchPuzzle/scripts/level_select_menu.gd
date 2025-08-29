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
	if is_instance_valid(GameData):
		last_completed_level_from_game_data = GameData.last_completed_level
		print("level_select_menu.gd: Último nível completado carregado do GameData = ", last_completed_level_from_game_data)
	else:
		print("level_select_menu.gd: Erro: Variável global 'GameData' não é válida. Progresso não será carregado no menu de seleção.")
		last_completed_level_from_game_data = 0 


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
			var hbox_container = overlay.get_node("HBoxContainer")
			var star_nodes = [
				hbox_container.get_node("Star"),
				hbox_container.get_node("Star2"),
				hbox_container.get_node("Star3")
			]
			level_star_icons[level_number] = star_nodes
			_atualizar_estrelas_do_nivel(level_number) # Chama para carregar as estrelas no início
			
			overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if hbox_container:
				hbox_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
				for star in star_nodes:
					if star:
						star.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			# Começa invisível para mostrar só no mouse (se o nível estiver desbloqueado)
			if level_number <= last_completed_level_from_game_data + 1:
				overlay.visible = false
				button.connect("mouse_entered", _on_button_mouse_entered.bind(overlay))
				button.connect("mouse_exited", _on_button_mouse_exited.bind(overlay))
			else:
				# Nível bloqueado → overlay sempre invisível, não responde ao mouse
				overlay.visible = false 

		# Bloqueio/desbloqueio de botões
		if level_number > last_completed_level_from_game_data + 1:
			button.disabled = true
			button.modulate = Color.GRAY # Opcional: Efeito visual para botão bloqueado
			if button.has_node("bg_overlay"):
				button.get_node("bg_overlay").visible = true # Mostra o bg_overlay para bloqueio
		else:
			button.connect("pressed", _on_level_button_pressed.bind(level_number))
			if button.has_node("bg_overlay"):
				button.get_node("bg_overlay").visible = false # Esconde o bg_overlay para desbloqueio


func _atualizar_estrelas_do_nivel(level_number: int):
	var recorde = 0
	if is_instance_valid(GameData):
		# Acesso às estrelas do GameData.level_stars usando a chave de STRING
		recorde = GameData.level_stars.get(str(level_number), 0) # Retorna 0 se o nível não tiver estrelas salvas
	else:
		print("level_select_menu.gd: Erro: GameData não é válido ao tentar atualizar estrelas.")

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
