extends PanelContainer

@onready var clear_button: Button = $MarginContainer/HBoxContainer/CommandsMenu/ExecuteArea/VBoxContainer/HBoxContainer/ClearButton

func _ready():
	if clear_button:
		clear_button.pressed.connect(_on_clear_button_pressed)



func _on_clear_button_pressed() -> void:
	get_tree().reload_current_scene()
