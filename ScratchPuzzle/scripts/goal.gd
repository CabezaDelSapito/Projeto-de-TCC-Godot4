extends Area2D


@onready var goal: Area2D = self
@onready var next_level_menu: CanvasLayer = $"../next_level_menu"

@onready var player: CharacterBody2D = $"../player"



func _on_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		player.parar()
		if is_instance_valid(SoundManager):
			SoundManager.play_won()
		
		var level = get_parent()  # Assumindo que o nível é o pai direto
		if level.has_method("concluir_objetivo_computador"):
			level.concluir_objetivo_computador()
			
		await get_tree().create_timer(0.5).timeout
		next_level_menu.visible = true
		await get_tree().create_timer(3).timeout
		get_tree().paused = true
		#transition.change_scene(next_level)

	else:
		print("No Scene Loaded")
