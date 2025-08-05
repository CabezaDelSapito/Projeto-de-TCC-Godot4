extends Area2D

@onready var transition: CanvasLayer = $"../transition"
@export var next_level : String = ""
@onready var goal: Area2D = self

@onready var player: CharacterBody2D = $"../player"



func _on_body_entered(body: Node2D) -> void:
	if body.name == 'player' && next_level != "":
		player.parar()
		transition.change_scene(next_level)
		var level = get_parent()  # Assumindo que o nível é o pai direto
		if level.has_method("concluir_objetivo_computador"):
			level.concluir_objetivo_computador()
	else:
		print("No Scene Loaded")
