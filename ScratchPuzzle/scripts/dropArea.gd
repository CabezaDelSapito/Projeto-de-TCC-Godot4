extends PanelContainer

@onready var target_node = find_child("GridContainer")
@onready var level_area: Node = get_tree().current_scene.find_child("LevelArea", true, false)  # Busca a LevelArea dinamicamente
var map: Node = null
var player: Node = null

func _ready():
	await get_tree().process_frame  # Aguarda um frame para garantir que os nós sejam carregados

	find_map_and_player()  # Chama a função para localizar os nós corretamente

func find_map_and_player():
	# Verifica se há mapas dentro de LevelArea
	if level_area and level_area.get_child_count() > 0:
		map = level_area.get_child(0)  # Assume que o primeiro filho de LevelArea é o mapa
	
	if map:
		player = map.find_child("player", true, false)  # Busca o nó "player" em qualquer nível do mapa
	
	if not player:
		print("⚠️ Player não encontrado no mapa!")

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true  # Pode modificar conforme necessário

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# Verifica se a posição mudou antes de adicionar o filho ao nó
	if data[0].get_parent() != target_node:
		target_node.add_child(data[0].duplicate())

func _on_execute_button_pressed() -> void:
	var comandos = []
	
	# Obtém todos os filhos do GridContainer e adiciona à lista de comandos
	for child in target_node.get_children():
		if child is TextureRect:
			#print("Comando:", child.name, " | Tipo:", child.CommandType)  # Acessando CommandType
			comandos.append(child)
	
	await executar_sequencial(comandos)

func executar_sequencial(comandos):
	# Garante que estamos pegando o player atualizado
	find_map_and_player()
	if not player:
		print("⚠️ Nenhum player encontrado para executar os comandos.")
		return
	
	for comando in comandos:
		match comando.CommandType:
			0:
				player.andar()
			1:
				player.virar()
			2:
				player.pular()
				
		await get_tree().create_timer(0.6).timeout  # Espera entre comandos
