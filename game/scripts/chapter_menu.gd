extends Control

@onready var tab_container : Node = $TabContainer
@onready var chapter_name : Node = $TabContainer/VBoxContainer/ChapterName
@onready var chapter_summary : Node = $TabContainer/VBoxContainer/ChapterSummary
@onready var chapter_artwork : Node = $TabContainer/VBoxContainer/ChapterArtwork
@onready var start_button : Node = $TabContainer/VBoxContainer/HBoxContainer/StartButton
@onready var continue_button : Node = $TabContainer/VBoxContainer/HBoxContainer/ContinueButton

@onready var checkpoint_menu : Node = $TabContainer/CheckpointMenu
@onready var back_button : Node = $BackButton

var chapter_menu_data : Dictionary = Utils.parse_json_as_dict("res://game/data/overworld_map_data/test_chapter_menu.json")
var chapter_scene : String = ""
var chapter_scene_directory : String = "res://game/scene_managers/"
var chapter_artwork_directory : String = "res://game/assets/textures/chapter_textures/"

func load_chapter_menu(key : String) -> void:
	var data: Dictionary = chapter_menu_data[key]
	var image : Image = load(chapter_artwork_directory + data["artwork"])
	
	chapter_name.text = data["name"]
	chapter_summary.text = data["summary"]
	chapter_artwork.texture = ImageTexture.create_from_image(image)
	chapter_scene = chapter_scene_directory + data["scene"]
	checkpoint_menu.load_checkpoints(data["checkpoints"], chapter_scene)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(chapter_scene)
	print("Change Scene To File: ", chapter_scene)


func _on_continue_button_pressed() -> void:
	tab_container.current_tab = 1
	back_button.show()


func _on_exit_button_pressed() -> void:
	tab_container.current_tab = 0
	hide()


func _on_back_button_pressed() -> void:
	tab_container.current_tab = 0
	back_button.hide()
