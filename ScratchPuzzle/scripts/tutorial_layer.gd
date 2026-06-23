extends Control

@onready var bg_overlay: ColorRect = $bg_overlay
@onready var label: Label = $Panel/Label
@onready var panel: Panel = $Panel

const TutorialStep = preload("res://scripts/tutorial_steps.gd").TutorialStep

var steps: Array = []
var step_index := 0
var command_block_text := ""

var current_step: TutorialStep = TutorialStep.OBJECTIVES

var _highlight_active := false

func _ready() -> void:
	# Recalcula o destaque sempre que a resolução do viewport mudar,
	# para a área vazada da máscara acompanhar os elementos de UI.
	get_viewport().size_changed.connect(_on_viewport_resized)

func setup_tutorial(step_list: Array, command_text: String) -> void:
	steps = step_list
	command_block_text = command_text
	step_index = 0

	if steps.is_empty():
		return

	current_step = steps[step_index]
	tutorial_step(current_step)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_next_step()

func _next_step() -> void:
	step_index += 1

	if step_index >= steps.size():
		_finish_tutorial()
		return

	current_step = steps[step_index]
	tutorial_step(current_step)

func restart_tutorial() -> void:
	visible = true
	step_index = 0
	if steps.is_empty():
		return
	current_step = steps[step_index]
	tutorial_step(current_step)


func _finish_tutorial() -> void:
	visible = false
	_highlight_active = false

func tutorial_step(step: TutorialStep) -> void:
	current_step = step
	match step:
		TutorialStep.OBJECTIVES:
			panel.position = Vector2(800, 60)
			label.text = "Este é o painel de objetivos.\nAqui você vê o que precisa fazer para completar o nível."

		TutorialStep.COMMANDS_AREA:
			panel.position = Vector2(450, 60)
			label.text = "Aqui ficam os comandos.\nArraste-os para área de execução para montar o algoritmo."

		TutorialStep.COMMANDS_BLOCK:
			panel.position = Vector2(450, 100)
			label.text = command_block_text

		TutorialStep.EXECUTION:
			panel.position = Vector2(500, 550)
			label.text = "Esta é a área de execução.\nClique em executar para rodar o algoritmo montado."

	_highlight_step_target(step)

# Resolve o nó de UI alvo de cada passo e destaca seu retângulo real,
# tornando a máscara responsiva a qualquer resolução.
func _highlight_step_target(step: TutorialStep) -> void:
	_highlight_active = true
	# Espera o layout estabilizar para obter os global_rect corretos.
	await get_tree().process_frame
	var target := _get_target_node(step)
	if target and target is Control:
		var rect: Rect2 = (target as Control).get_global_rect()
		var radius_px: float = max(rect.size.x, rect.size.y) * 0.65
		highlight_position(rect.get_center(), radius_px)

func _get_target_node(step: TutorialStep) -> Node:
	var root := get_tree().current_scene
	if root == null:
		return null
	match step:
		TutorialStep.OBJECTIVES:
			return root.get_node_or_null("MarginContainer/LevelInfo")
		TutorialStep.COMMANDS_AREA, TutorialStep.COMMANDS_BLOCK:
			return root.get_node_or_null("MarginContainer/LeftColumn/CommandArea")
		TutorialStep.EXECUTION:
			return root.get_node_or_null("MarginContainer/LeftColumn/ExecuteArea")
	return null

func _on_viewport_resized() -> void:
	if visible and _highlight_active:
		_highlight_step_target(current_step)

func highlight_position(pixel_position: Vector2, radius_px: float) -> void:
	var viewport_size: Vector2 = get_viewport_rect().size

	var normalized_pos: Vector2 = pixel_position / viewport_size
	var normalized_radius: float = radius_px / viewport_size.x

	var material: ShaderMaterial = bg_overlay.material as ShaderMaterial
	material.set_shader_parameter("hole_position", normalized_pos)
	material.set_shader_parameter("hole_radius", normalized_radius)
