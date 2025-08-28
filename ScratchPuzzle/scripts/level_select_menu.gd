extends Control

# Array to hold references to all level buttons
var level_buttons = []
# 'last_completed_level' agora será acessado diretamente do GameData,
# então esta variável local não é mais estritamente necessária aqui se você a usar apenas no _ready.
# No entanto, se precisar dela em outros lugares deste script, pode mantê-la e atribuir o valor do GameData a ela.
var last_completed_level_from_game_data: int = 0 

@onready var transition: CanvasLayer = $transition

func _ready():
	# Carrega o progresso do Singleton GameData
	last_completed_level_from_game_data = GameData.last_completed_level

	transition.visible = false
	
	# Get all button nodes
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
	
	# Configure os botões e overlays com base no progresso salvo
	for i in range(level_buttons.size()):
		var button = level_buttons[i]
		var level_number = i + 1
		
		button.text = "Level %d" % level_number
		
		# Tenta pegar o overlay, se existir
		var overlay = null
		if button.has_node("bg_overlay"):
			overlay = button.get_node("bg_overlay")

		# Se o nível atual for maior que o último nível completado + 1, ele está bloqueado
		# Usa 'last_completed_level_from_game_data' para verificar o progresso
		if level_number > last_completed_level_from_game_data + 1:
			button.disabled = true # Desabilita o botão para não ser clicável
			if overlay:
				overlay.visible = true # Mostra o overlay para indicar que está bloqueado
		else:
			# Se o nível estiver desbloqueado
			button.connect("pressed", _on_level_button_pressed.bind(level_number))
			if overlay:
				overlay.visible = false # Esconde o overlay para desbloquear o nível

func _on_level_button_pressed(level_number: int):
	# Start transition effect
	transition.change_scene("level_%d" % level_number)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed('ui_cancel'):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
