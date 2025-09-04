extends GridContainer

@export var love_host_button_scene : PackedScene

var host_selects : Array
var host_data_directory : String = "res://game/data/love/test_hosts.json"
var host_data : Array = Utils.parse_json_as_array(host_data_directory)

signal host_selected

func load_love_host_buttons() -> void:
	for i : Dictionary in host_data:
		var instance : Node = love_host_button_scene.instantiate()
		add_child(instance)
		instance.load_data(i)
		instance.host_selected.connect(_on_host_selected)
		host_selects.append(instance)
	print("Loaded Love Host Bulttons, ", host_selects)


func _on_host_selected(key: String, file_name: String) -> void:
	host_selected.emit(key, file_name)
