extends Node

var last_completed_level: int = 0
var level_stars: Dictionary = {} # Exemplo: {1: 2, 2: 3, 3: 1}

func _ready():
	load_progress()

func save_progress(level_to_save: int, stars_earned: int):
	# Atualiza o progresso de níveis
	if level_to_save > last_completed_level:
		last_completed_level = level_to_save

	# Atualiza recorde de estrelas do nível
	if !level_stars.has(level_to_save) or stars_earned > level_stars[level_to_save]:
		level_stars[level_to_save] = stars_earned

	# Salva tudo em arquivo
	var save_file = FileAccess.open("user://game_progress.dat", FileAccess.WRITE)
	if save_file:
		var data = {
			"last_completed_level": last_completed_level,
			"level_stars": level_stars
		}
		save_file.store_line(JSON.stringify(data))
		save_file.close()
		print("GameData.gd: Progresso salvo:", data)
	else:
		print("GameData.gd: Erro ao abrir arquivo para salvar.")

func load_progress():
	if FileAccess.file_exists("user://game_progress.dat"):
		var save_file = FileAccess.open("user://game_progress.dat", FileAccess.READ)
		if save_file:
			var line = save_file.get_line()
			if line != "":
				var data = JSON.parse_string(line)
				if typeof(data) == TYPE_DICTIONARY:
					last_completed_level = data.get("last_completed_level", 0)
					level_stars = data.get("level_stars", {})
					print("GameData.gd: Progresso carregado:", data)
			save_file.close()
	else:
		print("GameData.gd: Nenhum progresso salvo encontrado.")
