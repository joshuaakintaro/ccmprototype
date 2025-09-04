extends Button

class_name ClassicScenarioButton

@onready var scenario_name : Node = $VBoxContainer/Name
@onready var scenario_completion : Node = $VBoxContainer/Completion

var scenario_id : String
signal show_details

func load_data(data: Dictionary) -> void:
	scenario_id = data["scenario_id"]
	scenario_name.text = data["name"]
	scenario_completion.text = str(data["completion"])
	print("Created button!")
	check_unlocked(data["unlocked"])


func check_unlocked(value : bool) -> void:
	if !value:
		disabled = true


func _on_pressed() -> void:
	show_details.emit(scenario_id)
