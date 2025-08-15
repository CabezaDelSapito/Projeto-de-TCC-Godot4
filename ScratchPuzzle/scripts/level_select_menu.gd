extends Control

# Array to hold references to all level buttons
var level_buttons = []
@onready var transition: CanvasLayer = $transition

func _ready():
	# Remova a linha abaixo. O nó 'transition' já é um filho de 'level_select_menu'.
	# add_child(transition)
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
	
	# Connect each button
	for i in range(level_buttons.size()):
		var button = level_buttons[i]
		var level_number = i + 1
		button.connect("pressed", _on_level_button_pressed.bind(level_number))
		button.text = "Level %d" % level_number

func _on_level_button_pressed(level_number: int):
	# Start transition effect
	transition.change_scene("level_%d" % level_number)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed('ui_cancel'):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
