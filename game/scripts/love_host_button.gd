extends Button

var host_name : String
var image : String

signal host_selected

func load_data(data: Dictionary) -> void:
	host_name = data["name"]
	text = host_name
	image = data["image"]




func _on_pressed() -> void:
	host_selected.emit(host_name, image)
