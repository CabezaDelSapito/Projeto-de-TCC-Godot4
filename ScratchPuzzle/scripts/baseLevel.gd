extends PanelContainer

@onready var clear_button: Button = $MarginContainer/HBoxContainer/CommandsMenu/ExecuteArea/VBoxContainer/HBoxContainer/ClearButton
@onready var map_container: Node = $MarginContainer/HBoxContainer/LevelMenu/MarginContainer/LevelArea
@onready var command_container: Node = $MarginContainer/HBoxContainer/CommandsMenu/CommandArea/VBoxContainer/ScrollContainer2/VBoxContainer/Movimentacao/MarginContainer/VBoxContainer
@onready var v_box_container = $MarginContainer/HBoxContainer/CommandsMenu/ExecuteArea/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer
@onready var execute_button = $MarginContainer/HBoxContainer/CommandsMenu/ExecuteArea/VBoxContainer/HBoxContainer/ExecuteButton

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
@export var commands: Dictionary = {
	"level_1": [preload("res://commands/ComandoAndar.tscn")],
	"level_2": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn") ],
	"level_3": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn"), preload("res://commands/ComandoEsperar.tscn")],
	"level_4": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn"), preload("res://commands/ComandoEsperar.tscn"), preload("res://commands/ComandoPular.tscn")],
	"level_5": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn"), preload("res://commands/ComandoEsperar.tscn"), preload("res://commands/ComandoPular.tscn"),preload("res://commands/ComandoParar.tscn")],
	"level_6": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn"), preload("res://commands/ComandoEsperar.tscn"), preload("res://commands/ComandoPular.tscn"),preload("res://commands/ComandoParar.tscn"),preload("res://commands/ComandoRepetir.tscn")],
	"level_7": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn"), preload("res://commands/ComandoEsperar.tscn"), preload("res://commands/ComandoPular.tscn"),preload("res://commands/ComandoParar.tscn"),preload("res://commands/ComandoRepetir.tscn"),preload("res://commands/ComandoSe.tscn")],
	"level_8": [preload("res://commands/ComandoAndar.tscn"), preload("res://commands/ComandoVirar.tscn"), preload("res://commands/ComandoEsperar.tscn"), preload("res://commands/ComandoPular.tscn"),preload("res://commands/ComandoParar.tscn"),preload("res://commands/ComandoRepetir.tscn"),preload("res://commands/ComandoSe.tscn")],
}

var current_map = null
var current_level = "level_8"
var player = null

func _ready():
	if clear_button and not clear_button.pressed.is_connected(_on_clear_button_pressed):
		clear_button.pressed.connect(_on_clear_button_pressed)

	load_level(current_level) # Carrega o primeiro mapa e seus comandos

func _on_clear_button_pressed() -> void:
	# Remove todos os filhos dentro do painel
	for child in v_box_container.get_children():
		child.queue_free()

func load_level(level_name: String):
	_on_clear_button_pressed()
	load_map(level_name)
	load_commands(level_name)

func load_map(level_name: String):
	execute_button.disabled = false
	if current_map:
		current_map.queue_free()  # Remove o mapa anterior
	
	if level_name in maps:
		current_map = maps[level_name].instantiate()
		current_map.scale = Vector2(1, 1)  # Ajusta a escala do mapa
		map_container.add_child(current_map)
		
		player = current_map.get_node("player")
		if player:
			# Conecta o sinal de morte do player a este script
			if not player.player_died.is_connected(_on_player_died):
				player.player_died.connect(_on_player_died)
		else:
			print("Player não encontrado no mapa!")

func _on_player_died():
	load_map(current_map.nome)

func load_commands(level_name: String):
	# Remove todos os comandos anteriores
	for child in command_container.get_children():
		child.queue_free()
	
	# Adiciona os novos comandos conforme o nível
	if level_name in commands:
		for command_scene in commands[level_name]:
			var command_instance = command_scene.instantiate()
			command_container.add_child(command_instance)


func _on_restart_button_pressed() -> void:
	load_map(current_map.nome)
