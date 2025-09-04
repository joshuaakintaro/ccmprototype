extends Button

class_name DynamicButton

### INFO: Allows for dynamic variable creation,
### and custom parameter set query for pressed function
var variables : Dictionary # Use this to add variables at runtime, shows in inspector

var parameter : Variant

signal send_parameter

func load_data(data: Dictionary) -> void:
	text = data["text"]
	variables = data["variables"] if data.has("variables") else {}
	set_parameter(data["parameter"])

func _on_pressed() -> void:
	if parameter != null:
		send_parameter.emit(variables[parameter])
	print("Button Pressed!")

func set_parameter(key : String) -> void:
	parameter = variables[key]
