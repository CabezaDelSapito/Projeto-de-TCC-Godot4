extends TextureRect

@export_enum("Andar", "Virar", "Pular") var CommandType = 0
#@export_enum("Loop", "Enquanto", "Se", "Senão") var Command = 0

func _get_drag_data(_at_position: Vector2) -> Variant:
	var data = [self, CommandType]
	#visible = false
	var preview = TextureRect.new()
	preview.texture = texture
	set_drag_preview(preview)
	
	return data

func _notification(notification_type) -> void:
		match notification_type:
			NOTIFICATION_DRAG_END:
				visible = true
