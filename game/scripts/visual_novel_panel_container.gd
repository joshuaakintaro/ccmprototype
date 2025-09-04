extends TextureRect

var panel_instances : Dictionary
var image_directory : String = "res://game/assets/visual_novel_panels/"
var image_extension : String = ".png"
var image : Image

func on_received_panel_data(panel_data : Dictionary) -> void:
	#Panel textures include size/dimension, name, and placement
	#Panel data would include how its introduced, and how to remove it
	
	var image_location : String = image_directory + panel_data["image"] + image_extension
	image = load(image_location)
	
	var image_dimensions : Vector2i = panel_data["dimensions"]
	image.resize(image_dimensions.x, image_dimensions.y)
	
	var texture : ImageTexture = ImageTexture.create_from_image(image)
	
	texture = texture
	
	
	
func remove_panel(key : String) -> void:
	panel_instances[key].queue_free()
	panel_instances.erase(key)
	
	
func panel_entry() -> void:
	# Determines fade-in, sudden, flash, etc
	pass
	
	
