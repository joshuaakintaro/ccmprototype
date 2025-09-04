extends Control

@export var classic_select_button_scene : PackedScene

@onready var classic_club_select = $ClassicClubSelect

var data_directory : String = "res://game/data/classic_data/classic_club_test.json"
var classic_club_select_data : Array = Utils.parse_json_as_array(data_directory)

signal show_menu

func _ready() -> void:
	classic_club_select.club_selected.connect(_on_club_selected)
	load_classic_select_buttons()


func load_classic_select_buttons() -> void:
	for i : Dictionary in classic_club_select_data:
		classic_club_select.load_classic_club_buttons(i)


func _on_club_selected(key : String) -> void:
	show_menu.emit(key)
