extends TextureRect

var background_directory : String = "res://game/assets/textures/visual_novel_textures/"
var background : Image

func change_background(file_name : String, transition : String) -> void:
	var file_location : String = background_directory + file_name
	background = load(file_location)
	set_transition(transition)
	texture = ImageTexture.create_from_image(background)
	print(file_location)
	
	
func set_transition(transition) -> void:
	if transition == "fade-in":
		pass
		
		
	elif transition == "greyscale":
		pass
		
		
