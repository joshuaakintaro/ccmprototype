extends Control

@onready var scenario_number : Node = $VBoxContainer/HBoxContainer/ScenarioNumber
@onready var scenario_name : Node = $VBoxContainer/HBoxContainer/ScenarioName
@onready var scenario_summary : Node = $VBoxContainer/ScenarioSummary
@onready var scenario_completion : Node = $VBoxContainer/ScenarioCompletion
@onready var start_button : Node = $VBoxContainer/StartButton

var vn_directory : String = "res://game/scene_managers/"
var scenario_scene : String = ""

func load_details(data: Dictionary, completion : int) -> void:
	scenario_number.text = data["number"]
	scenario_name.text = data["name"]
	scenario_summary.text = data["summary"]
	scenario_completion.text = str(completion) + "%"
	start_button.pressed.connect(_on_start_button_pressed)
	scenario_scene = vn_directory + data["scene"]


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(scenario_scene)
