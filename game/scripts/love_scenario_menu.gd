extends Control

@onready var love_scenario_select : Node = $HBoxContainer/LoveScenarioSelect
@onready var love_scenario_details : Node = $HBoxContainer/LoveScenarioDetails

var current_key : String
var love_scenario_data : Array

var data_directory = "res://game/data/love/love_scenario_test"

func _ready() -> void:
	love_scenario_select.show_details.connect(_on_show_details)

func load_love_scenario_data(key : String) -> void:
	current_key = key.to_lower()
	var directory : String = (data_directory) + ("_" + current_key + ".json")
	love_scenario_data = Utils.parse_json_as_array(directory)


func load_love_scenario_buttons() -> void:
	love_scenario_details.hide()
	for data : Dictionary in love_scenario_data:
		love_scenario_select.load_love_scenario_button(data)
		###TODO: SOLVE THIS, WHAT IS ID SUPPOSED TO MEAN WHEN THERE IS SCENARIO ID???

func reset_buttons() -> void:
	for i : Node in love_scenario_select.love_scenario_buttons:
		i.queue_free()
	love_scenario_select.love_scenario_buttons.clear()
	print("Reset buttons")


func _on_show_details(scenario_id: String) -> void:
	love_scenario_details.show()
	for i: Dictionary in love_scenario_data:
		if i["scenario_id"] == scenario_id:
			love_scenario_details.load_details(i["details"], i["completion"])
			print("Showing details...")
			break
