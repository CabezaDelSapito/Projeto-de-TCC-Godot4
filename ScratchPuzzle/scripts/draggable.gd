extends TextureRect

@export_enum("Estrutura", "Movimento", "Direcao") var CommandType = 0

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = [self, CommandType]
	var preview = TextureRect.new()
	preview.texture = texture
	set_drag_preview(preview)
	
	return data
	

