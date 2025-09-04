extends Control

@onready var create_match_button = $VBoxContainer/HBoxContainer/CreateRoomButton
@onready var join_match_button = $VBoxContainer/HBoxContainer/JoinRoomButton
@onready var room_browser_button = $VBoxContainer/HBoxContainer2/RoomBrowserButton
@onready var join_match_prompt = $JoinMatchPrompt

var create_room_manager_path : String = ""

func _on_create_room_button_pressed() -> void:
	get_tree().change_scene_to_file(create_room_manager_path)


func _on_join_room_button_pressed() -> void:
	join_match_prompt.show()
