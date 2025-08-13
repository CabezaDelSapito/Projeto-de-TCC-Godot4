extends CanvasLayer

@onready var restart_button: Button = $menu_holder/HBoxContainer2/RestartButton
@onready var transition: CanvasLayer = $"../transition"

@export var next_level : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_next_button_pressed() -> void:
	get_tree().paused = false
	if next_level != "":
		transition.change_scene(next_level)
	else:
		get_tree().change_scene_to_file("res://scenes/level_select_menu.tscn")

func _on_restart_button_pressed() -> void:
	var current_num = int(next_level.get_slice("_", 1)) # Pega o número depois do "_"
	var previous_num = current_num - 1
	var previous_level = "level_%d" % previous_num

	get_tree().paused = false
	if next_level != "":
		transition.change_scene(previous_level)
	else:
		print("next level not declared")

