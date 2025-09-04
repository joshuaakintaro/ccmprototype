extends Area2D

class_name HostSelectCharacter

@onready var animated_sprite_2d : Node = $AnimatedSprite2D
@onready var collision_shape_2d : Node = $CollisionShape2D

var host_name : String

var drag_offset: Vector2 = Vector2.ZERO
var last_position : Vector2
var last_click_position : Vector2
var is_dragging = false

var sprite_frame_directory : String = Global.host_selects_sprites_directory

signal quick_selected

var TEST : bool = true ## TESTING

func load_sprite(host : String) -> void:
	host_name = host
	var location : String = "hosts/" + host + "_spriteframes.tres"
	if TEST:
		location = "test/test_sprite_frames.tres"

	if host_name == "RANDOM":
		location = "random/random_sprite_frames.tres"

	animated_sprite_2d.sprite_frames = load(sprite_frame_directory + location)
	load_collision_shape()


func load_collision_shape() -> void:
	var texture : Texture2D = animated_sprite_2d.sprite_frames.get_frame_texture("default", 0)
	collision_shape_2d.shape.size = Vector2(texture.get_width(), texture.get_height())


func _process(delta) -> void:
	if is_dragging:
		position = get_global_mouse_position() + drag_offset


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_dragging and event.pressed: #draggin must be false and pres must be true
			start_dragging()
			last_click_position = event.position
		if is_dragging and not event.pressed: #dragging must be true and press must be false
			stop_dragging()
			position = last_position
			check_last_click(event.position)

func start_dragging() -> void:
	#set_collision_layer(2)
	last_position = position
	is_dragging = true
	get_viewport().set_input_as_handled()


func stop_dragging() -> void:
	#set_collision_layer(1)
	is_dragging = false
	get_viewport().set_input_as_handled()


func check_last_click(current_click_position : Vector2) -> void:
	var top_range = current_click_position + Vector2(0,0)
	var bottom_range = current_click_position - Vector2(0,0)
	if last_click_position <= top_range and last_click_position >= bottom_range:
		quick_selected.emit(host_name)
		print("Quick selected!")
