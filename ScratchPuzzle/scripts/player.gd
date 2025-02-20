extends CharacterBody2D

const SPEED = 218.75
const JUMP_VELOCITY = -400.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_moving := false  # Define se está andando ou não
var direction := 1  # 1 = Direita, -1 = Esquerda

@onready var texture := $AnimatedSprite2D as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Adiciona a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Aplica o movimento apenas se estiver andando
	if is_moving:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_set_state()
	move_and_slide()

func _set_state():
	var state = 'idle'
	
	if !is_on_floor():
		state = 'jump'
	elif is_moving:
		state = 'run'
	
	if texture.name != state:
		texture.play(state)

# ====== COMANDOS EXTERNOS ======

# Inicia o movimento do personagem na direção atual
func andar():
	is_moving = true

# Vira o personagem para a direção oposta
func virar():
	direction *= -1
	texture.scale.x = -direction

# Faz o personagem pular
func pular():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

# Para o movimento
func parar():
	is_moving = false
	
func esperar(tempo):
	await get_tree().create_timer(tempo).timeout  # Espera entre comandos
