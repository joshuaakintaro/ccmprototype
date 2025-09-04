extends VBoxContainer

# WARNING: Shares redundant code with classic scenario select

@export var love_scenario_button_scene : PackedScene

var love_scenario_buttons : Array

signal show_details

func load_love_scenario_button(data: Dictionary) -> void:
	var instance : Node = love_scenario_button_scene.instantiate()
	add_child(instance)
	instance.load_data(data)
	instance.show_details.connect(_on_show_details)
	love_scenario_buttons.append(instance)


func _on_show_details(id: String) -> void:
	show_details.emit(id)
