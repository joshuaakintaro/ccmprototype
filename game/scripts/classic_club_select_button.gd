extends Button

var key : String
var texture : Texture2D

var image_directory : String = "res://game/assets/textures/club_selects/"

signal club_selected

func load_data(data : Dictionary) -> void:
	key = data["key"]
	var image : Image = load(image_directory + data["image"])
	texture = ImageTexture.create_from_image(image)
	self_modulate = data["colour"]
	text = key
	print("Created select button with key: ", data["key"])


func _on_pressed() -> void:
	club_selected.emit(key)
	print("Club: ", key, " selected!")
