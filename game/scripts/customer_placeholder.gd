extends StaticBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var circle_shape_2d = $CollisionShape2D.get_shape()

@export var speed : float

func set_shape(radius : float, shape_position: Vector2) -> void:
	$CollisionShape2D.get_shape().radius = radius
	position = shape_position
	
	
func _process(delta: float) -> void:
	position.y = position.y + (1 * speed)
	
	
