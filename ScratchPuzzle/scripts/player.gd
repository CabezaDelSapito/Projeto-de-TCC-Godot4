extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var direction
var is_walking := false

@onready var texture := $AnimatedSprite2D as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimentação pelo teclado (ainda pode ser usada manualmente)
	direction = Input.get_axis("ui_left", "ui_right")

	# Se o jogador estiver em movimento automático, usa a direção do comando "Andar"
	if is_walking:
		print("andando sozinho")
		velocity.x += direction * SPEED
	else:
		# Se não estiver andando automaticamente, usa a entrada do jogador
		if direction:
			velocity.x = direction * SPEED
			texture.scale.x = -direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	_set_state()
	move_and_slide()

func _set_state():
	var state = 'idle'
	
	if !is_on_floor():
		state = 'jump'
	elif direction:
		state = 'run'
	
	if texture.name != state:
		texture.play(state)

func andar(direcao: int):
	is_walking = true
	direction = direcao  # Define a direção para continuar andando
	velocity.x = direcao * SPEED
	move_and_slide()

# Para o movimento contínuo
func parar():
	is_walking = false
	velocity.x = 0
	move_and_slide()


func pular():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY  # Faz o personagem pular
		await get_tree().create_timer(2.0).timeout  # Espera um pouco no ar

