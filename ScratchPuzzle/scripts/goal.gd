extends Area2D

@onready var transition: CanvasLayer = $"../transition"
@export var next_level : String = ""
@onready var goal: Area2D = $"."

func _on_body_entered(body: Node2D) -> void:
	if body.name == 'player' && !next_level == "":
		transition.change_scene(next_level)
	else:
		print("No Scene Loaded")
