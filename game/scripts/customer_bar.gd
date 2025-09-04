extends StaticBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var rectangle_shape_2d = $CollisionShape2D.get_shape()

@export var speed : float

var extra_height : int

func set_shape(shape_size : Vector2, shape_position: Vector2) -> void:
	rectangle_shape_2d.size = shape_size
	rectangle_shape_2d.size.y -= extra_height
	position = shape_position
	
	
func _process(delta: float) -> void:
	if position.y > 0:
		position.y = position.y + (1* speed)
		
	
	
