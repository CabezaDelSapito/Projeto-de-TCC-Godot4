extends Node2D

@export var nome : String = ""
@export var comandos: Array[PackedScene] = []
@export var stars: Array[String] = ["ACESSE O COMPUTADOR", "", ""]

# Objetivos configuráveis
@export var comando_requerido: String = "andar"  # Comando específico para estrela 2
@export var max_comandos: int = 1                # Máximo de comandos para estrela 3

var total_comandos_usados := 0
var comandos_usados := []

# Variáveis para rastrear objetivos
var objetivos_concluidos := [false, false, false]  # Computador, Comando Específico, Máx Comandos

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	stars[1] = "USE O COMANDO " + comando_requerido.to_upper()
	stars[2] = "USE NO MÁXIMO %d COMANDOS" % max_comandos
	resetar_objetivos()

func resetar_objetivos():
	objetivos_concluidos = [false, false, false]

# Chamado quando o jogador alcança o computador
func concluir_objetivo_computador():
	objetivos_concluidos[0] = true
	atualizar_ui_objetivos()

# Chamado quando um comando é executado
func registrar_comando(nome_comando: String):
	total_comandos_usados += 1
	comandos_usados.append(nome_comando)
	
	# Verifica se o comando específico foi usado
	if nome_comando == comando_requerido:
		objetivos_concluidos[1] = true
	
	# Verifica limite de comandos
	objetivos_concluidos[2] = (total_comandos_usados <= max_comandos)
	
	atualizar_ui_objetivos()

func atualizar_ui_objetivos():
	if has_node("/root/Main"):  # Ajuste para o caminho do seu nó principal
		get_node("/root/Main").atualizar_estrelas(objetivos_concluidos)
