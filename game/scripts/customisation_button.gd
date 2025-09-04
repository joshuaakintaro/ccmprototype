extends TextureButton

signal button_data_pass
var id_data : int

func initalise(data: Dictionary) -> void:
	texture_normal = data["image_path"]
	id_data = data["id"]
	
	
func _on_pressed() -> void:
	button_data_pass.emit(id_data)
	
	
