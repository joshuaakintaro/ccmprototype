extends Area2D

class_name CustomerArea

@export var position_width_percentage : float
@export var position_height_percentage : float
@export var size_width_percentage : float
@export var size_height_percentage : float


@onready var collision_shape_2d = $CollisionShape2D
@onready var rectangle_shape_2d = collision_shape_2d.shape

var extra_height : int

func _ready() -> void:
	set_area_shape()
	
	
func set_area_shape() -> void:
	position = Utils.get_screen_dimensions(position_width_percentage, position_height_percentage)
	
	rectangle_shape_2d.size = Utils.get_screen_dimensions(size_width_percentage, size_height_percentage)
	rectangle_shape_2d.size.y += extra_height
	
	
func _on_body_entered(body: Customer) -> void:
	body.current_drop_zone = self
	
	
func _on_body_exited(body: Customer) -> void:
	if body.current_drop_zone == self:
		body.current_drop_zone = null
	
	
func get_size() -> Vector2:
	return rectangle_shape_2d.size
	
	
## INFO: get_position() is native in Node class
