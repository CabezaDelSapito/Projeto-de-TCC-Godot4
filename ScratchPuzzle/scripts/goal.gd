extends Area2D

@onready var transition: CanvasLayer = $"../transition"
@export var next_level : String = ""
@onready var goal: Area2D = $"."

func _unhandled_input(event):
	if goal.get_overlapping_bodies().size() > 0 && event.is_action_pressed("interact") && !next_level == "":
		transition.change_scene(next_level)
	else:
		print("No Scene Loaded")

