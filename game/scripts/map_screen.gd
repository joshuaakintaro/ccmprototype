extends Node2D


@export var poi_scene : PackedScene
@onready var map_texture : Node = $MapTexture

var poi_data : Array = Utils.parse_json_as_array("res://game/data/overworld_map_data/test_poi.json")
var poi_index : Dictionary
var poi_id : int

signal show_menu

func _ready() -> void:
	load_pois()


func load_pois() -> void:
	for i : Dictionary in poi_data:
		var poi_instance : Node = poi_scene.instantiate()
		map_texture.add_child(poi_instance)
		poi_instance.load_data(i)
		poi_instance.pressed.connect(_on_pressed)
		poi_instance.id = poi_id
		poi_index[poi_id] = poi_instance


func increment_poi_id() -> void:
	poi_id += 1


func _on_pressed(id : int) -> void:
	show_menu.emit(poi_index[id])
	print("Passed POI of id: ", id)
