extends Area2D

@onready var collision_shape_2d : Node = $CollisionShape2D
var fake_animated_sprite_2d : Node
var real_animated_sprite_2d : Node

var id : int

var host_name: String
var level: int
var appearance : Dictionary
var status : Dictionary
var performance : Dictionary
var special : Dictionary

var is_occupied : bool # Might be useless
var is_input_enabled : bool = true
var sprite_frame_directory : String = Global.host_selects_sprites_directory

var TEST : bool = true ## TESTING

signal manually_selected
signal active_target
signal unactive_target

func load_selected_host_data(data : Dictionary) -> void:
	host_name = data.get("name")
	appearance = data.get("appearance")
	status = data.get("status")
	performance = data.get("performance")
	special = data.get("special")

	create_real_sprite()
	load_real_sprite()

func create_real_sprite() -> void:
	real_animated_sprite_2d = AnimatedSprite2D.new()
	add_child(real_animated_sprite_2d)


func load_real_sprite() -> void:
	var location : String = host_name + "_spriteframes.tres"
	if TEST:
		location = "test/test_sprite_frames.tres" ## TESTING
	real_animated_sprite_2d.sprite_frames = load(sprite_frame_directory + location)

func reset() -> void:
	host_name = ""
	level = 0
	appearance = {}
	status = {}
	performance = {}
	special = {}
	
	if real_animated_sprite_2d != null:
		real_animated_sprite_2d.queue_free()
		remove_child(real_animated_sprite_2d)
		is_occupied = false


func _on_area_entered(area: Area2D) -> void:
	if is_input_enabled:
		if area is HostSelectCharacter and area.is_dragging:
			if fake_animated_sprite_2d == null:
				# INFO: Creates faded preview of character when hovering over
				# INFO: Hides current character if it exists
				active_target.emit(self)
				if real_animated_sprite_2d != null:
					real_animated_sprite_2d.hide()
				fake_animated_sprite_2d = AnimatedSprite2D.new()
				var new_sprite_frame : SpriteFrames = area.animated_sprite_2d.sprite_frames
				fake_animated_sprite_2d.sprite_frames = new_sprite_frame
				fake_animated_sprite_2d.self_modulate.a = 0.5
				add_child(fake_animated_sprite_2d)


func _on_area_exited(area: Area2D) -> void:
	if is_input_enabled:
		unactive_target.emit()
		if area is HostSelectCharacter and area.is_dragging == false:
			# Character select, so removed preview and emit signal to get real character
			if fake_animated_sprite_2d != null:
				fake_animated_sprite_2d.queue_free()
				remove_child(fake_animated_sprite_2d)
			
			#In other words, we must allow replacement with manual
			# But have an exception if it's the same
			# Actually we can just remove the reference
			manually_selected.emit(area.host_name, self)
			is_occupied = true


		if area is HostSelectCharacter and area.is_dragging:
			if fake_animated_sprite_2d != null:
				fake_animated_sprite_2d.queue_free()
				remove_child(fake_animated_sprite_2d)
			if real_animated_sprite_2d != null:
					real_animated_sprite_2d.show()
