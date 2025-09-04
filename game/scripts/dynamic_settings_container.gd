extends VBoxContainer

class_name DynamicSettingsContainer

### INFO: Dynamically create new settings and set and get them

signal update_settings

func new_setting(data : Dictionary) -> void:
	var hbox_instance : HBoxContainer = HBoxContainer.new()
	add_child(hbox_instance)

	var label_instance : Label = Label.new()
	hbox_instance.add_child(label_instance)
	label_instance.text = data["label"]

	var button_instance : DynamicButton = DynamicButton.new()
	hbox_instance.add_child(button_instance)
	button_instance.load_data(data["button_data"])
	button_instance.send_parameter.connect(_on_button_pressed)
	# TODO: For some reason, pressing button isn't emitting the signal properly...


func _on_button_pressed(key : String, value : Variant) -> void:
	print("test")
	update_settings.emit(key, value)
