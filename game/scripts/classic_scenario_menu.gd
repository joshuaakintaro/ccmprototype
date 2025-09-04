extends Control

class_name ClassicScenarioMenu

@onready var background : Node = $Background
@onready var classic_scenario_select : Node = $HBoxContainer/ClassicScenarioSelect
@onready var classic_scenario_details : Node = $HBoxContainer/ClassicScenarioDetails

var current_key : String
var club_scenario_data : Array
var data_directory = "res://game/data/classic_data/classic_scenario_test"

const BACKGROUND : Dictionary = {
	"johnny" : "test_johnny_background.png",
}

var background_directory : String = "res://game/assets/textures/club_selects/"

func _ready() -> void:
	classic_scenario_select.show_details.connect(_on_show_details)


func load_background() -> void:
	var image_file : String = BACKGROUND[current_key]
	var image : Image = load(background_directory + image_file)
	background.texture = ImageTexture.create_from_image(image)


func load_club_scenario_data(key : String) -> void:
	current_key = key
	var directory : String = (data_directory) + ("_" + current_key + ".json")
	club_scenario_data = Utils.parse_json_as_array(directory)


func load_save_file() -> void:
	var save_data : Dictionary = Global.get_save_file()
	var scenario_data : Dictionary = save_data["scenario"]

	for i : Dictionary in club_scenario_data:
		if scenario_data.has(i["scenario_id"]):
			var scenario_id : String = i["scenario_id"]
			i["unlocked"] = scenario_data[scenario_id]["unlocked"]
			i["completion"] = scenario_data[scenario_id]["completion"]

func load_classic_scenario_buttons() -> void:
	classic_scenario_details.hide()
	for i : Dictionary in club_scenario_data:
		var button_data : Dictionary = {
			"scenario_id" : i["scenario_id"],
			"name" : i["name"],
			"unlocked" : i["unlocked"],
			"completion" : i["completion"]
		}
		classic_scenario_select.load_classic_scenario_buttons(button_data)


func reset_buttons() -> void:
	for i : Node in classic_scenario_select.classic_scenario_buttons:
		i.queue_free()
	classic_scenario_select.classic_scenario_buttons.clear()
	print("Reset buttons")


func _on_show_details(scenario_id : String) -> void:
	classic_scenario_details.show()
	for i: Dictionary in club_scenario_data:
		if i["scenario_id"] == scenario_id:
			classic_scenario_details.load_details(i["details"], i["completion"])
			print("Showing details...")
			break
