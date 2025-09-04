extends VBoxContainer

@export var classic_scenario_button_scene : PackedScene

var classic_scenario_buttons : Array

signal show_details

func load_classic_scenario_buttons(data: Dictionary) -> void:
	var instance : Node = classic_scenario_button_scene.instantiate()
	add_child(instance)
	instance.load_data(data)
	instance.show_details.connect(_on_show_details)
	classic_scenario_buttons.append(instance)


func _on_show_details(scenario_id : String) -> void:
	show_details.emit(scenario_id)
