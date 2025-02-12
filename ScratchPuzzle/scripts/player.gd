extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var direction

@onready var texture := $AnimatedSprite2D as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
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

func andar():
	velocity.x = direction * SPEED  # Anda na direção atual
	await get_tree().create_timer(1.0).timeout  # Anda por 1 segundo
	velocity.x = 0  # Para após o tempo
