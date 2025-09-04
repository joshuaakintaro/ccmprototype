extends Control

@onready var background : Node = $Background
@onready var map_preview : Node = $MapPreview
@onready var gameplay_map_buttons_container : Node = $VBoxContainer/GameplayMapButtonsContainer
@onready var back_button : Node = $BackButton
@onready var start_button : Node = $StartButton

var current_map : String

var map_preview_directory : String = "res://game/assets/textures/gameplay_map_previews/"

signal go_back

func _ready() -> void:
	gameplay_map_buttons_container.load_buttons()
	gameplay_map_buttons_container.selected_map.connect(_on_selected_map)


func _on_selected_map(payload : Dictionary) -> void:
	var location : String = map_preview_directory + payload["map_preview"] + ".png"
	map_preview.texture = load(location)
	map_preview.show()
	start_button.show()
	
	current_map = payload["map_id"]


func _on_back_button_pressed() -> void:
	go_back.emit()


func _on_start_button_pressed() -> void:
	Global.current_map = current_map
	get_tree().change_scene_to_file(Global.host_select_path)
