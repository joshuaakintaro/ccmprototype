extends Node2D


@onready var map_screen : Node = $MapScreen
@onready var chapter_menu : Node = $CanvasLayer/ChapterMenu

var key_data : Dictionary = Utils.parse_json_as_dict("res://game/data/overworld_map_data/test_chapter_menu.json")

func _ready() -> void:
	map_screen.show_menu.connect(_on_show_menu)


func _on_show_menu(poi_instance : Node) -> void:
	var key = poi_instance.chapter
	chapter_menu.load_chapter_menu(key)
	chapter_menu.show()
