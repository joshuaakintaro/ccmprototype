extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var circle_shape_2d = collision_shape_2d.get_shape()

var is_occupied : bool = false
var occupied_counter : int

func set_shape(shape_size: float, shape_position: Vector2) -> void:
	circle_shape_2d.set_radius(shape_size)
	position = shape_position
	
	
func _on_body_entered(body: Node2D) -> void:
	if body is Customer:
		is_occupied = true
		occupied_counter += 1
		
		
func _on_body_exited(body: Node2D) -> void:
		if body is Customer:
			occupied_counter -=1
			if occupied_counter == 0:
				is_occupied = false
