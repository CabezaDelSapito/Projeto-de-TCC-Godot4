extends PanelContainer

@onready var map_container: Node = $MarginContainer/LevelArea
@onready var command_container: Node = $MarginContainer/CommandsMenu/CommandArea/VBoxContainer/PanelContainer/GridContainer
@onready var execute_area: VBoxContainer = $MarginContainer/CommandsMenu/ExecuteArea/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer
@onready var clear_button: Button = $MarginContainer/CommandsMenu/ExecuteArea/VBoxContainer/HBoxContainer/ClearButton
@onready var execute_button = $MarginContainer/CommandsMenu/ExecuteArea/VBoxContainer/HBoxContainer/ExecuteButton
@onready var star_icons := [
	$MarginContainer/LevelMenu/LevelInfo/VBoxContainer/HBoxContainer/Star,
	$MarginContainer/LevelMenu/LevelInfo/VBoxContainer/HBoxContainer2/Star,
	$MarginContainer/LevelMenu/LevelInfo/VBoxContainer/HBoxContainer3/Star
]

# Texturas para estrelas (configure no Inspector)
@export var star_texture: Texture2D
@export var gray_star_texture: Texture2D

@export var maps: Dictionary = {
	"level_1": preload("res://levels/level_1.tscn"),
	"level_2": preload("res://levels/level_2.tscn"),
	"level_3": preload("res://levels/level_3.tscn"),
	"level_4": preload("res://levels/level_4.tscn"),
	"level_5": preload("res://levels/level_5.tscn"),
	"level_6": preload("res://levels/level_6.tscn"),
	"level_7": preload("res://levels/level_7.tscn"),
	"level_8": preload("res://levels/level_8.tscn")
}

var current_map = null
var current_level = "level_8"
var player = null

func _ready():
	add_to_group("MainNode")
	if clear_button and not clear_button.pressed.is_connected(_on_clear_button_pressed):
		clear_button.pressed.connect(_on_clear_button_pressed)

	load_level(current_level) # Carrega o primeiro mapa e seus comandos

func load_level(level_name: String):
	_on_clear_button_pressed()
	load_map(level_name)
	update_level_info(level_name)

func load_map(level_name: String):
	execute_button.disabled = false
	if current_map:
		current_map.queue_free()  # Remove o mapa anterior
	
	if level_name in maps:
		current_map = maps[level_name].instantiate()
		current_map.main_node = self
		#current_map.scale = Vector2(1, 1)  # Ajusta a escala do mapa
		map_container.add_child(current_map)
		
		player = current_map.get_node("player")
		if player:
			# Conecta o sinal de morte do player a este script
			if not player.player_died.is_connected(_on_player_died):
				player.player_died.connect(_on_player_died)
		else:
			print("Player não encontrado no mapa!")
		load_commands()

func load_commands():
	# Remove todos os comandos anteriores
	for child in command_container.get_children():
		child.queue_free()
	
	# Adiciona os novos comandos conforme o nível
	if current_map and "comandos" in current_map:
		for command_scene in current_map.comandos:
			if command_scene:  # Verifica se a cena é válida
				var command_instance = command_scene.instantiate()
				command_container.add_child(command_instance)

func update_level_info(level_name: String):
	# Obtém o título do nível (por exemplo, LEVEL 1, LEVEL 2, etc.)
	$MarginContainer/LevelMenu/LevelInfo/VBoxContainer/LevelTitle.text = "LEVEL " + level_name.split("_")[1]
	
	# Adiciona os novos stars conforme o nível
	if current_map and "stars" in current_map:
		# Acessa as estrelas do nível atual
		var level_stars = current_map.stars
		
		# Verifica se o array de estrelas tem o tamanho esperado
		if level_stars.size() == 3:
			# Atualiza as labels das estrelas
			$MarginContainer/LevelMenu/LevelInfo/VBoxContainer/HBoxContainer/Label.text = level_stars[0]  # Atualiza a primeira estrela
			$MarginContainer/LevelMenu/LevelInfo/VBoxContainer/HBoxContainer2/Label.text = level_stars[1]  # Atualiza a segunda estrela
			$MarginContainer/LevelMenu/LevelInfo/VBoxContainer/HBoxContainer3/Label.text = level_stars[2]  # Atualiza a terceira estrela
		
			# Inicializa estrelas como cinzas
			resetar_estrelas()

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

func _on_player_died():
	load_map(current_map.nome)

func _on_restart_button_pressed() -> void:
	# Reseta os objetivos antes de recarregar o mapa
	if current_map and current_map.has_method("resetar_objetivos"):
		current_map.resetar_objetivos()
	# Recarrega o mapa
	load_map(current_map.nome)
	# Atualiza a UI para mostrar estrelas cinzas
	resetar_estrelas()
	
func _on_clear_button_pressed() -> void:
	# Remove todos os filhos dentro do painel
	for child in execute_area.get_children():
		child.queue_free()

func _on_execute_button_pressed() -> void:
	current_map.process_mode = ProcessMode.PROCESS_MODE_INHERIT
	
	for command in execute_area.get_children():
		if current_map.has_method("registrar_comando"):
			# Converta o CommandType para o nome correspondente
			var command_names = ["andar", "virar", "pular", "parar", "esperar", "repetir", "se"]
			if command.CommandType < command_names.size():
				current_map.registrar_comando(command_names[command.CommandType])
