extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var estrutura: Node = $"."  # Inicialmente pega a cena raiz

func _ready():
	# Verifica se `baseLevel` está na cena e o atribui corretamente
	estrutura = get_tree().current_scene 
	if not estrutura:
		print("⚠️ baseLevel não encontrado na cena!")

func change_scene(next_level, delay = 0.5):
	visible = 1
	var scene_transition = get_tree().create_tween()
	scene_transition.tween_property(color_rect, 'threshold', 1.0, 0.5).set_delay(delay)
	await scene_transition.finished
	visible = 0
	
	if estrutura and estrutura.has_method("load_level"):
		estrutura.load_level(next_level)  # Chama a função para carregar o próximo nível dinamicamente
	else:
		print("⚠️ Estrutura não encontrada ou método load_level não existe.")
	


func show_new_scene():
	var show_transition = get_tree().create_tween()
	show_transition.tween_property(color_rect, "threshold", 0.0, 0.5).from(1.0)
