extends TextureRect

@export_enum("Andar", "Virar", "Pular", "Parar", "Esperar", "Repetir", "Se") var CommandType = 0
@export var valor: float = 1.0  # Novo campo para armazenar um número inteiro
@onready var tempo_input: SpinBox = $TempoInput
@export var repeat_count: int = 1  # Quantas vezes repetir
@onready var command_container = $VBoxContainer  # Onde os comandos dentro do repetir serão armazenados
@onready var repeticao_input = $repeticaoInput
@onready var option_button: OptionButton = $OptionButton

# Definição das opções condicionais
enum Condicao {
	NO_CHAO, 
	#IMPULSIONADO, 
	#AGARRADO, 
	PARADO, 
	CAINDO, 
	#ORBE_COLETADO, 
	#TELEPORTADO, 
	#NAO
}



#bloco SE
func _ready():
	_preencher_condicoes()

func _preencher_condicoes():
	option_button.clear()
	for cond in Condicao.keys():
		option_button.add_item(cond)

# Verifica se a condição escolhida é verdadeira
func verificar_condicao() -> bool:
	var condicao_atual = obter_estado_jogador()  # Implementar essa função conforme seu jogo
	var condicao_selecionada = option_button.get_selected_id()

	return condicao_atual == condicao_selecionada

# Obtém os comandos, mas só executa se a condição for verdadeira
func executar_comandos():
	if verificar_condicao():
		var comandos = get_comandos()
		for comando in comandos:
			var bloco = comando[0]  # Bloco de comando
			var tempo = comando[1]  # Tempo associado ao comando
			bloco.executar(tempo)  # Assumindo que cada bloco tenha um método "executar"

#Bloco Repetir e Se
func get_comandos():
	var comandos = []
	for child in command_container.get_children():
		if child is TextureRect:
			var tempo = child.get_valor() if child.has_method("get_valor") else 1.0
			comandos.append([child, tempo])
	return comandos



#Bloco Repetir
func get_repeat_count() -> int:
	return int(repeticao_input.value) if repeticao_input else repeat_count  # Pega o valor do SpinBox

#Bloco esperar
func get_valor() -> float:
	return float(tempo_input.value) if tempo_input else 1.0





#configuração geral
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
