extends Node2D

class_name HostSelectMenu

@export var host_select_character_scene : PackedScene

@onready var chosen_host_area_1 : Node = $ChosenHostArea
@onready var chosen_host_area_2 : Node = $ChosenHostArea2
@onready var chosen_host_area_3 : Node = $ChosenHostArea3

@onready var canvas_layer : Node = $CanvasLayer

@onready var chosen_host_areas : Array = [chosen_host_area_1, chosen_host_area_2, chosen_host_area_3]

@onready var area_available : Dictionary = {
	"1" : {
		"area" : chosen_host_area_1,
		"bool" : true
	},
	"2" : {
		"area" : chosen_host_area_2,
		"bool" : true
	},
	"3" : {
		"area" : chosen_host_area_3,
		"bool" : true
	}
}

var random_character : Dictionary = {
		"name": "RANDOM",
		"appearance": {
			"allure": 0,
			"cuteness": 0,
			"elegance": 0,
			"striking": 0,
		},
		"status" : {
			"stamina": 0,
			"mood": 0,
		},
		"performance" : {
			"charm": 0,
			"empathy": 0,
			"physical_resilience": 0,
			"emotional_resilience": 0,
			"luck": 0,
		},
		"special" : {
			"skill_id": "RANDOM_SKILL",
			"ability_id": "RANDOM_ABILITY",
		}
	}

var current_host_area : Node
var host_selects : Array
var host_names : Array

var host_data_directory : String = "res://game/data/hosts/test_hosts.json"
var host_data : Array = Utils.parse_json_as_array(host_data_directory)

func _ready() -> void:
	load_select_menu()

func load_select_menu() -> void:
	set_host_names()
	load_characters()
	load_random_character()
	set_to_grid_points()
	assign_areas()


func assign_areas() -> void:
	for i : int in chosen_host_areas.size():
		chosen_host_areas[i].id = i
		chosen_host_areas[i].manually_selected.connect(_on_manually_selected)
		chosen_host_areas[i].active_target.connect(_on_active_target)
		chosen_host_areas[i].unactive_target.connect(_on_unactive_target)
		## INFO ON BUG: If you remove assign_areas() from ready
		## Chosen host areas will use quick selection, and it still wont work


func load_characters() -> void:
	for i : Dictionary in host_data:
		var hsc_instance : Node = host_select_character_scene.instantiate()
		add_child(hsc_instance)
		hsc_instance.load_sprite(i["name"])
		hsc_instance.quick_selected.connect(_on_quick_selected)
		host_selects.append(hsc_instance)
	# Random character instance


func load_random_character() -> void:
	var hsc_instance : Node = host_select_character_scene.instantiate()
	add_child(hsc_instance)
	hsc_instance.load_sprite(random_character["name"])
	hsc_instance.quick_selected.connect(_on_quick_selected)
	host_selects.append(hsc_instance)


func set_to_grid_points() -> void:
	var texture : Texture2D = host_selects[0].animated_sprite_2d.sprite_frames.get_frame_texture("default", 0)
	var texture_size : Vector2 = Vector2(texture.get_width(), texture.get_height())
	var grid_points : Array
	
	var x_offset : int = 560
	var y_offset : int = 100
	
	var x_modifier : int
	var y_modifier : int = 0
	
	for i in host_selects.size():
		if i == 3:
			x_modifier = i
			y_modifier = 1
		if i == 11:
			x_modifier = 11
			y_modifier = 2
		var x = (texture_size.x * (i-1-x_modifier)) + (texture_size.x * 1/2) + x_offset
		var y = (texture_size.y * (y_modifier)) + (texture_size.y * 1/2) + y_offset

		grid_points.append(Vector2(x,y))
		host_selects[i].position = grid_points[i]


func _on_quick_selected(host : String) -> void:
	for i : Node in chosen_host_areas:
		#BUG: All nodes take previous name
		if i.host_name == host:
			print("Can only use different characters per host!")
			return
	if host == "RANDOM":
		host = get_random_host() # Has validation for duplicates

	for i : Dictionary in host_data:
		if i["name"] == host:
			var area : Node = quick_choose_area()
			area.load_selected_host_data(i)
			print("Quick Selected ", host, " in position ", (area.id + 1))
			return


func quick_choose_area() -> Node:
	for i : String in area_available:
		if area_available[i]["bool"]:
			area_available[i]["bool"] = false
			return area_available[i]["area"]
	return area_available["3"]["area"]


func _on_manually_selected(host : String, chosen_area : Node) -> void:
	var is_replacing : bool 
	print(chosen_area.host_name)
	for i : Node in chosen_host_areas:
		if i.host_name == host:
			i.reset()
			print(host, " Removed. Moving to chosen position.")
			is_replacing = true
			break

	if host == "RANDOM":
		host = get_random_host() # Has validation for duplicates

	for i : Dictionary in host_data:
		if i["name"] == host:
			chosen_area.load_selected_host_data(i)
			if is_replacing:
				print("Moved ", host, " to position: ", (chosen_area.id + 1))
			else:
				print("Manually Selected ", host, " in position: ", (chosen_area.id + 1))

	for k : String in area_available:
		if area_available[k]["area"] == chosen_area:
			area_available[k]["bool"] = false
			print("Set ", chosen_area, " to occupied")


func _on_active_target(area: Node) -> void:
	print("Deactivating host areas.")
	for i : Node in chosen_host_areas:
		if i != area:
			i.is_input_enabled = false


func _on_unactive_target() -> void:
	print("Reactivating host areas.")
	for i : Node in chosen_host_areas:
		i.is_input_enabled = true


func _on_start_button_pressed() -> void:
	for i : String in area_available:
		if area_available[i]["bool"]:
			print("Needs a full team!")
			return

	set_host_team()
	if Global.randomise_enemy:
		print("Randomising enemies...")
		set_random_enemy_team()
	print("Moving to scene path...")
	get_tree().change_scene_to_file(Global.host_select_path)
	# By default goes to level


func _on_reset_button_pressed() -> void:
	for i : Node in chosen_host_areas:
		i.reset()
		#print(i.get_children())
	for i : String in area_available:
		area_available[i]["bool"] = true


func get_random_host() -> String:
	var random_host : String
	while true:
		var randi : int = randi_range(0, host_names.size() - 1)
		random_host = host_names[randi]
		var temp : bool
		for i : Node in chosen_host_areas:
			if i.host_name == random_host:
				print("Random host %s already exists...Generating another host..." % random_host)
				temp = true
				break
		if temp:
			continue
		print("Found host: %s not existent in other chosen_areas. Proceeding.." % random_host)
		print("\n")
		break
	return random_host


func set_host_team() -> void:
	Global.player_team.clear()
	for i : Node in chosen_host_areas:
		Global.player_team.append(i.host_name)
	print("Player Team entered: %s." % [Global.player_team])


func set_random_enemy_team() -> void:
	Global.random_team("enemy")


func set_host_names() -> void:
	for i : Dictionary in host_data:
		host_names.append(i["name"])
