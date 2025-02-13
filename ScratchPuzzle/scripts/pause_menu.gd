extends CanvasLayer

@onready var resume_button: Button = $menu_holder/ResumeButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event) -> void:
	if event.is_action_pressed('ui_cancel'):
		visible = true
		get_tree().paused = true
		resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()
