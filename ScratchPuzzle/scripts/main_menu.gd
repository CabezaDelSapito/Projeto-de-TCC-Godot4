extends Control
class_name MainMenu

func _ready() -> void:
	for _button in get_tree().get_nodes_in_group("button"):
		_button.pressed.connect(_on_button_pressed.bind(_button))

func _on_button_pressed(_button: Button) -> void:
	match _button.name:
		"PlayButton":
			get_tree().change_scene_to_file("res://levels/baseLevel.tscn")
		"CreditsButton":
			pass
		"QuitButton":
			get_tree().quit()
