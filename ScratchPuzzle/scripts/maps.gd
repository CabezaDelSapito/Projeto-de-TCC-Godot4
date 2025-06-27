extends Node2D

@export var nome : String = ""
@export var comandos: Array[PackedScene] = []
@export var stars: Array[String] = ["ACESSE O COMPUTADOR", "", ""]

# Objetivos configuráveis
@export var comando_requerido: String = "andar"  # Comando específico para estrela 2
@export var max_comandos: int = 1                # Máximo de comandos para estrela 3

var total_comandos_usados := 0
var comandos_usados := []

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	# Atualiza textos das estrelas
	stars[1] = "USE O COMANDO " + comando_requerido.to_upper()
	stars[2] = "USE NO MÁXIMO %d COMANDOS" % max_comandos
	
