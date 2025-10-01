extends CanvasLayer

@onready var restart_button: Button = $menu_holder/HBoxContainer2/RestartButton
@onready var transition: CanvasLayer = $"../transition"
@export var next_level : String = ""

##############################################################
@onready var star_icons := [
	$menu_holder/HBoxContainer/Star,
	$menu_holder/HBoxContainer/Star2,
	$menu_holder/HBoxContainer/Star3
]
# Texturas para estrelas (configure no Inspector)
@export var star_texture: Texture2D
@export var gray_star_texture: Texture2D

# Função para atualizar o visual das estrelas
func atualizar_estrelas(objetivos: Array):
	for i in range(star_icons.size()):
		if i < objetivos.size():
			if objetivos[i]:
				star_icons[i].texture = star_texture
			else:
				star_icons[i].texture = gray_star_texture

func resetar_estrelas():
	for star in star_icons:
		star.texture = gray_star_texture
	
	
#################################################################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	resetar_estrelas()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_quit_button_pressed() -> void:
	if is_instance_valid(SoundManager):
		SoundManager.play_button()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_next_button_pressed() -> void:
	if is_instance_valid(SoundManager):
		SoundManager.play_button()
	get_tree().paused = false
	if next_level != "":
		transition.change_scene(next_level)
	else:
		get_tree().change_scene_to_file("res://scenes/level_select_menu.tscn")

func _on_restart_button_pressed() -> void:
	if is_instance_valid(SoundManager):
		SoundManager.play_button()
	var current_num = int(next_level.get_slice("_", 1)) # Pega o número depois do "_"
	var previous_num = current_num - 1
	var previous_level = "level_%d" % previous_num

	get_tree().paused = false
	if next_level != "":
		transition.change_scene(previous_level)
	else:
		print("next level not declared")

