extends Control

@onready var love_host_button_container : Node = $LoveHostButtonContainer
@onready var character_art : Node = $CharacterArt
@onready var love_scenario_menu : Node = $LoveScenarioMenu
@onready var next_button : Node = $NextButton
var current_host : String

var love_artwork_directory : String = "res://game/assets/textures/love_artwork/"

func _ready() -> void:
	love_host_button_container.host_selected.connect(_on_host_selected)
	love_host_button_container.load_love_host_buttons()


func _on_host_selected(key: String, file_name : String) -> void:
	current_host = key
	var image : Image = load(love_artwork_directory + file_name)
	character_art.texture = ImageTexture.create_from_image(image)
	next_button.show()


func _on_next_button_pressed() -> void:
	love_host_button_container.hide()
	next_button.hide()
	love_scenario_menu.show()
	love_scenario_menu.load_love_scenario_data(current_host)
	love_scenario_menu.load_love_scenario_buttons()


func _on_back_button_pressed() -> void:
	love_scenario_menu.reset_buttons()
	love_scenario_menu.hide()
	love_host_button_container.show()
	next_button.show()
