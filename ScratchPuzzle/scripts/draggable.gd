extends TextureRect

@export_enum("Andar", "Virar", "Pular", "Parar", "Esperar", "Repetir", "Se") var CommandType = 0
@export var valor: float = 1.0
@onready var tempo_input: SpinBox = $TempoInput
@export var repeat_count: int = 1
@onready var command_container = $VBoxContainer
@onready var repeticao_input = $repeticaoInput
@onready var condition_option = $OptionButton
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

# Chamado quando o nó é inicializado
func _ready():
	# Configura as opções de condição apenas se for um comando "Se"
	if CommandType == 6: # "Se" é o índice 6 no export_enum
		_setup_condition_options()

func _process(_delta):
	if CommandType in [5, 6] and command_container:
		# espera o layout atualizar
		await get_tree().process_frame
		
		var total_height = 30
		for child in command_container.get_children():
			total_height += child.get_combined_minimum_size().y + command_container.get_theme_constant("separation")
		
		custom_minimum_size.y = total_height
		nine_patch_rect.custom_minimum_size.y = total_height - 15



# Configura as opções de condição no OptionButton
func _setup_condition_options():
	if condition_option:
		condition_option.clear()
		condition_option.add_item("Está no chão?")
		condition_option.add_item("Há obstáculo à frente?")
		condition_option.add_item("Está virado para direita?")
		condition_option.add_item("Está virado para esquerda?")
		condition_option.add_item("Há um buraco à frente?")

# Retorna o tipo de condição selecionada (apenas para comando "Se")
func get_condition() -> String:
	if CommandType == 6 && condition_option:
		match condition_option.selected:
			0: return "on_ground"
			1: return "obstacle_ahead"
			2: return "facing_right"
			3: return "facing_left"
			4: return "hole_ahead"
	return ""

func get_comandos():
	var comandos = []
	for child in command_container.get_children():
		if child is TextureRect:
			var tempo = child.get_valor() if child.has_method("get_valor") else 1.0
			comandos.append([child, tempo])
	return comandos

func get_repeat_count() -> int:
	return int(repeticao_input.value) if repeticao_input else repeat_count

func get_valor() -> float:
	return float(tempo_input.value) if tempo_input else 1.0

func _get_drag_data(_at_position: Vector2) -> Variant:
	var data = [self, CommandType, valor]
	var preview = TextureRect.new()
	preview.texture = texture
	set_drag_preview(preview)
	return data

func _notification(notification_type) -> void:
	match notification_type:
		NOTIFICATION_DRAG_END:
			visible = true
