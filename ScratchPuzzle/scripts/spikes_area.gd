extends Area2D

@export var rect_w: float = 88.0  # Valor exportado para o rect_w

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#collision_shape_2d.shape.size = sprite_2d.get_rect().size
	# Ativa o modo de região para permitir ajustes no tamanho do Sprite2D.
	sprite_2d.region_enabled = true

	# Define a largura da região com base no valor exportado de rect_w.
	var region_rect := sprite_2d.region_rect
	region_rect.size.x = rect_w
	sprite_2d.region_rect = region_rect

	# Ajusta o tamanho do CollisionShape2D com base no novo tamanho do Sprite2D.
	# Godot 4: RectangleShape2D usa "size" (dimensão inteira), não "extents".
	# Duplica o shape para não alterar as outras instâncias que compartilham o recurso.
	var shape := collision_shape_2d.shape.duplicate() as RectangleShape2D
	shape.size = Vector2(rect_w, sprite_2d.texture.get_size().y)
	collision_shape_2d.shape = shape

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
