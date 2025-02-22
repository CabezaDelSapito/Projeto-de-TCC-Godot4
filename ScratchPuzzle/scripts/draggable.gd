extends TextureRect

@export_enum("Andar", "Virar", "Pular", "Parar", "Esperar", "Repetir") var CommandType = 0
@export var valor: float = 1.0  # Novo campo para armazenar um número inteiro
#@export_enum("Loop", "Enquanto", "Se", "Senão") var Command = 0
@onready var tempo_input: SpinBox = $TempoInput
@export var repeat_count: int = 1  # Quantas vezes repetir
@onready var command_container = $VBoxContainer  # Onde os comandos dentro do repetir serão armazenados
@onready var repeticao_input = $repeticaoInput

func get_comandos():
	var comandos = []
	for child in command_container.get_children():
		if child is TextureRect:
			var tempo = child.get_valor() if child.has_method("get_valor") else 1.0
			comandos.append([child, tempo])
	return comandos

func get_repeat_count() -> int:
	return int(repeticao_input.value) if repeticao_input else repeat_count  # Pega o valor do SpinBox

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
