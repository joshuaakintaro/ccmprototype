extends StaticBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var segment_2d = collision_shape_2d.get_shape()

var extra_height : int
var margin_of_error : int = -1

func set_shape(area_size: Vector2, area_position: Vector2) -> void:
	var position_x1 : float = area_position.x - (area_size.x / 2)
	var position_x2 : float = area_position.x + (area_size.x / 2)
	segment_2d.set_a(Vector2(position_x1, -extra_height + margin_of_error))
	segment_2d.set_b(Vector2(position_x2, -extra_height + margin_of_error))
	print(segment_2d.a, segment_2d.b)
	print(segment_2d.get_rect())
	print(position)
