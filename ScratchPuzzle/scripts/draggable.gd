extends TextureRect

@export_enum("Andar", "Virar", "Pular", "Parar", "Esperar") var CommandType = 0
@export var valor: float = 1.0  # Novo campo para armazenar um número inteiro
#@export_enum("Loop", "Enquanto", "Se", "Senão") var Command = 0
@onready var tempo_input: SpinBox = $TempoInput

func get_valor() -> float:
	return float(tempo_input.value) if tempo_input else 1 

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
