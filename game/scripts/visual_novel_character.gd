extends AnimatedSprite2D


# Attributes
var priority : int
var speaking : bool
var character : String
var expression : String

var sprite_folder_directory : String = "res://game/assets/sprites/characters/"

func output_values() -> void:
	print(character)
	print(expression)
	print(get_spriteframes_directory())


func load_spriteframes() -> void:
	# Loads spriteframes
	sprite_frames = load(get_spriteframes_directory())
	position = Vector2(640,256)
	
	
func normal_animation() -> void:
	# Loops default expression
	play(expression)
	


func speaking_animation() -> void:
	var talking : String = expression + "_talking"
	if get_animation() != talking:
		stop()
		set_animation(talking)
		pass
	else:
		var temp : int= frame + 1
		if temp > (sprite_frames.get_frame_count(talking) - 1):
			temp = 0
		frame = temp
		print(frame)


func _on_fadeout() -> void:
	pass
	
	
func get_spriteframes_directory() -> String:
	return sprite_folder_directory + character + "/" + character + "_spriteframes.tres"
	
	
func set_character(character_name : String) -> void:
	character = character_name
	
	
func set_expression(expression_name : String) -> void:
	expression = expression_name
	
	
