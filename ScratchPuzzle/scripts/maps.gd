extends Node2D

@export var nome : String = ""
@export var comandos: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = ProcessMode.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
