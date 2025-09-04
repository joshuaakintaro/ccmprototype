extends HBoxContainer

@export var gameplay_map_button_scene : PackedScene

var data_directory : String = "res://game/data/gameplay_maps/test_gameplay_maps.json"
var gameplay_map_data : Array = Utils.parse_json_as_array(data_directory)

var gameplay_map_buttons : Array

signal selected_map

func load_buttons() -> void:
	for data : Dictionary in gameplay_map_data:
		var instance : Node = gameplay_map_button_scene.instantiate()
		add_child(instance)
		instance.load_data(data)
		instance.selected_map.connect(_on_selected_map)
		gameplay_map_buttons.append(instance)


func _on_selected_map(payload : Dictionary) -> void:
	selected_map.emit(payload)
