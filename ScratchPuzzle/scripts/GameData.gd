# GameData.gd
extends Node

# last_completed_level guarda o número do maior nível que o jogador já completou.
# É inicializado como 0, o que significa que nenhum nível foi completado ainda.
var last_completed_level: int = 0

func _ready():
	# Quando o GameData (Autoload) é carregado na inicialização do jogo,
	# ele automaticamente tenta carregar o progresso salvo.
	last_completed_level = load_progress() 
	print("GameData.gd: Carregado. Último nível completado: ", last_completed_level)

# Esta função é chamada por outras partes do seu jogo (por exemplo, o script de cada nível)
# para registrar que um nível foi completado.
func save_progress(level_to_save: int):
	# Só salva se o nível que acabou de ser completado (level_to_save)
	# for maior do que o último nível já salvo (last_completed_level).
	# Isso garante que o progresso só avança, nunca retrocede ao rejogar níveis.
	if level_to_save > last_completed_level: 
		last_completed_level = level_to_save # Atualiza a variável interna do GameData

		# Abre o arquivo de progresso em modo de escrita.
		# "user://" aponta para um diretório persistente no dispositivo do usuário.
		var save_file = FileAccess.open("user://game_progress.dat", FileAccess.WRITE)
		if save_file:
			# Escreve o número do nível completado no arquivo como uma string.
			save_file.store_line(str(last_completed_level))
			save_file.close() # Fecha o arquivo após escrever.
			print("GameData.gd: Progresso salvo: Último nível completado = ", last_completed_level)
		else:
			print("GameData.gd: Erro: Não foi possível abrir o arquivo de progresso para escrita.")
	else:
		print("GameData.gd: Nível ", level_to_save, " concluído, mas não é um novo recorde. Progresso não salvo.")

# Esta função é chamada para carregar o progresso do jogo do arquivo salvo.
# Retorna o número do último nível completado, ou 0 se nenhum progresso for encontrado.
func load_progress() -> int:
	var progress = 0
	# Verifica se o arquivo de progresso existe.
	if FileAccess.file_exists("user://game_progress.dat"):
		# Abre o arquivo em modo de leitura.
		var save_file = FileAccess.open("user://game_progress.dat", FileAccess.READ)
		if save_file:
			var line = save_file.get_line() # Lê a primeira linha do arquivo.
			if line != "": # Garante que a linha não está vazia.
				progress = int(line) # Converte a linha lida para um número inteiro.
			save_file.close()
			print("GameData.gd: Progresso carregado: Último nível completado = ", progress)
	else:
		print("GameData.gd: Arquivo de progresso não encontrado. Iniciando com progresso 0.")
	return progress
