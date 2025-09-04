extends AnimatedSprite2D

@onready var area_2d : Node = $Area2D
@onready var collision_shape_2d : Node = $Area2D/CollisionShape2D

var id : int
var chapter : String

var sprite_frames_directory = "res://game/assets/sprites/pois/test_pois/new_sprite_frames.tres"

signal pressed

func load_data(data: Dictionary) -> void:
	position = Vector2(data["position"][0],data["position"][1])
	sprite_frames = load(sprite_frames_directory)
	load_collision_shape()
	chapter = data["chapter"]


func load_collision_shape() -> void:
	var texture : Texture2D = sprite_frames.get_frame_texture("default", 0)
	collision_shape_2d.shape.size = texture.get_size()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			pressed.emit(id)
			print("Pressed POI, passed ID")
