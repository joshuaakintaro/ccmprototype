extends StaticBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var segment_2d = collision_shape_2d.get_shape()

var extra_height : int

func set_shape(area_size: Vector2, area_position: Vector2) -> void:
	var position_x : float = area_position.x + (area_size.x / 2)
	var least_y_position : float = Utils.get_screen_dimensions().y
	segment_2d.set_a(Vector2(position_x, 0 - extra_height))
	segment_2d.set_b(Vector2(position_x, least_y_position))
	
	
