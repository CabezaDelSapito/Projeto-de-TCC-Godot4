extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
var estrutura: Node = null  # We'll store the reference dynamically

func _ready():
	# Connect to scene change signal
	get_tree().connect("current_scene_changed", _on_scene_changed)
	# Get initial reference
	_update_estrutura_reference()

func _on_scene_changed():
	_update_estrutura_reference()

func _update_estrutura_reference():
	estrutura = get_tree().current_scene
	if not estrutura:
		print("⚠️ baseLevel não encontrado na cena!")

func change_scene(next_level, delay = 0.5):
	visible = true
	var scene_transition = get_tree().create_tween()
	scene_transition.tween_property(color_rect, 'threshold', 1.0, 0.5).set_delay(delay)
	await scene_transition.finished
	
	# Notificar todos os nós para preparar para mudança de cena
	get_tree().call_group("execution_areas", "prepare_for_scene_change")
	
	_update_estrutura_reference()
	
	if is_instance_valid(estrutura) and estrutura.has_method("load_level"):
		estrutura.load_level(next_level)
	else:

		# Fallback: direct scene loading
		var level_scene = load("res://levels/baseLevel.tscn")
		var new_level = level_scene.instantiate()
		
		# Set the level if the new scene has this property
		if new_level.has_method("set_current_level"):
			new_level.set_current_level(next_level)
		elif "current_level" in new_level:
			new_level.current_level = next_level
		
		get_tree().root.add_child(new_level)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = new_level
		estrutura = new_level
		
	get_tree().call_group("execution_areas", "scene_change_completed")
	show_new_scene()

func show_new_scene():
	var show_transition = get_tree().create_tween()
	show_transition.tween_property(color_rect, "threshold", 0.0, 0.5).from(1.0)
	visible = false
