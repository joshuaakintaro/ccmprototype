extends Button

var map_id : String
var map_name : String
var preview : String

var gameplay_button_images_directory : String

signal selected_map

func load_data(data : Dictionary) -> void:
	map_id = data["map_id"]
	map_name = data["name"]
	text = map_name
	set_texture(data["image"])
	preview = data["map_preview"]

func set_texture(image_directory : String) -> void:
	## INFO: some image to texture function for textrect
	var location : String = gameplay_button_images_directory + image_directory + ".png"
	#texture = load(location)
	pass



func _on_pressed() -> void:
	var payload : Dictionary = {
		"map_id" : map_id,
		"map_preview" : preview
	}
	selected_map.emit(payload)
