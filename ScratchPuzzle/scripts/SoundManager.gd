extends Node

@onready var jump_player = $JumpPlayer
@onready var ground_player = $GroundPlayer
#@onready var land_player: AudioStreamPlayer = $LandPlayer
#@onready var hit_player = $HitPlayer
#@onready var death_player = $HitPlayer
#@onready var button_player = $ButtonPlayer
#@onready var fail_player = $FailPlayer
#@onready var won_player = $WonPlayer
#@onready var applause_player = $ApplausePlayer
#@onready var music_player: AudioStreamPlayer = $MenuMusicPlayer
#@onready var endless_player: AudioStreamPlayer = $EndlessMusicPlayer
#@onready var squash_player = $SquashPlayer

#var land_sound: AudioStream
#var ground_sound: AudioStream
#var hit_sound: AudioStream
#var death_sound: AudioStream
#var button_sound: AudioStream
var jump_sounds: Array[AudioStream]
#var menu_music: AudioStream
#var fail_music: AudioStream
#var won_music: AudioStream
#var applause_sound: AudioStream
#var squash_sound: AudioStream
#var music_playing := false
#var endless_playing := false
#var game_musics: Array[AudioStream] = []
#var endless_music: AudioStream

func _ready():
	#menu_music = load("res://Assets/Sounds/main_music.ogg")  
	#ground_sound = load("res://Assets/Sounds/tap.ogg")  
	#hit_sound = load("res://Assets/Sounds/hit.ogg")  
	#death_sound = load("res://Assets/Sounds/death.ogg") 
	#button_sound = load("res://Assets/Sounds/click.ogg") 
	#applause_sound = load("res://Assets/Sounds/applause.ogg") 
	#fail_music = load("res://Assets/Sounds/losetrumpet.ogg") 
	#won_music = load("res://Assets/Sounds/won.ogg") 
	#squash_sound = load("res://Assets/Sounds/squash.ogg") 
	jump_sounds = [
		load("res://assets/Sounds/CartoonJump.ogg"),
		load("res://assets/Sounds/jump2.ogg"),
	]
	#game_musics = [
	#load("res://Assets/Sounds/music1.ogg"),
	#load("res://Assets/Sounds/music2.ogg"),
	#load("res://Assets/Sounds/music3.ogg"),
	#]
	#endless_music = load("res://Assets/Sounds/endless.ogg")
	#
	#endless_player.volume_db = -5
	
func _process(_delta):
	var current_scene = get_tree().current_scene
	if current_scene == null:
		return  # ainda carregando ou trocando de cena

	var scene_name = current_scene.name
	#if scene_name == "Game":
		#if (not music_playing or music_player.stream == menu_music) and not endless_playing:
			#stop_music()
			#play_random_game_music()
	#
	#else:
		#if not music_playing or music_player.stream != menu_music:
			#if endless_playing:
				#play_endless_music()
			#else:
				#stop_music()
				#play_music()
		

#func play_random_game_music():
	#if music_playing:
		#return
#
	#var selected = game_musics[randi() % game_musics.size()]
	#music_player.stream = selected
	#music_player.play()
	#music_playing = true
	
#func play_music():
	#stop_endless_music()
	#
	#if music_playing:
		#return
	#music_player.stream = menu_music
	#music_player.play()
	#music_playing = true

#func play_endless_music():
	#stop_music()
		#
	#if endless_playing:
		#return
		#
	#endless_player.stream = endless_music
	#endless_player.play()
	#endless_playing = true

#func stop_music():
	#music_player.stop()
	#music_playing = false
		#
#func stop_endless_music():
	#endless_player.stop()
	#endless_playing = false
	#
#func play_won():
	#won_player.stream = won_music
	#won_player.play()
	#applause_player.stream = applause_sound
	#applause_player.play()
	
#func play_fail():
	#fail_player.stream = fail_music
	#fail_player.play()
	#
#func play_button():
	#button_player.stream = button_sound
	#button_player.play()
	#
#func play_ground():
	#ground_player.stream = ground_sound
	#ground_player.play()
	#
#func play_land():
	#if land_player and land_sound:
		#land_player.stream = land_sound
		#land_player.play()
	
#func play_hit():
	#hit_player.stream = hit_sound
	#hit_player.play()
#
#func play_death():
	#death_player.stream = death_sound
	#death_player.play()
	#
#func play_squash():
	#squash_player.stream = squash_sound
	#squash_player.play()
	
func play_jump():
	if jump_sounds.size() == 0:
		return
	var index = randi() % jump_sounds.size()
	jump_player.stream = jump_sounds[index]
	jump_player.play()
	
#func stop_all_sounds():
	#for player in [jump_player, ground_player, hit_player, death_player, fail_player, won_player, applause_player, music_player, endless_player]:
		#if player.playing:
			#player.stop()
	#music_playing = false
	#endless_playing = false
