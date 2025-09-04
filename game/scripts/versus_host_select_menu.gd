extends HostSelectMenu


@onready var player_host_area_1 : Node = $PlayerHostArea
@onready var player_host_area_2 : Node = $PlayerHostArea2
@onready var player_host_area_3 : Node = $PlayerHostArea3

@onready var enemy_host_area_1 : Node = $EnemyHostArea
@onready var enemy_host_area_2 : Node = $EnemyHostArea2
@onready var enemy_host_area_3 : Node = $EnemyHostArea3

@onready var player_host_areas : Array = [player_host_area_1, player_host_area_2, player_host_area_3]
@onready var enemy_host_areas : Array = [enemy_host_area_1, enemy_host_area_2, enemy_host_area_3]

@onready var player_area_available : Dictionary = {
	"1" : {
		"area" : player_host_area_1,
		"bool" : true
	},
	"2" : {
		"area" : player_host_area_2,
		"bool" : true
	},
	"3" : {
		"area" : player_host_area_3,
		"bool" : true
	}
}

@onready var enemy_area_available : Dictionary = {
	"4" : {
		"area" : enemy_host_area_1,
		"bool" : true
	},
	"5" : {
		"area" : enemy_host_area_2,
		"bool" : true
	},
	"6" : {
		"area" : enemy_host_area_3,
		"bool" : true
	}
}

@onready var gameplay_map_select : Node = $CanvasLayer/GameplayMapSelect
@onready var versus_select : Node = $CanvasLayer/VersusSelect
@onready var custom_select_menu : Node = $CanvasLayer/VersusSelect/CustomSelectMenu

func _ready() -> void:
	chosen_host_areas = player_host_areas + enemy_host_areas
	area_available = player_area_available.merged(enemy_area_available)
	
	load_select_menu()
	gameplay_map_select.go_back.connect(_on_go_back)

func assign_areas() -> void:
	for i : int in chosen_host_areas.size():
		chosen_host_areas[i].id = i
		chosen_host_areas[i].manually_selected.connect(_on_manually_selected)
		chosen_host_areas[i].active_target.connect(_on_active_target)
		chosen_host_areas[i].unactive_target.connect(_on_unactive_target)
		## INFO ON BUG: If you remove assign_areas() from ready
		## Chosen host areas will use quick selection, and it still wont work
	for area : Node in player_host_areas:
		area.active_target.connect(_on_player_active_target)
		area.unactive_target.connect(_on_player_unactive_target)
	for area : Node in enemy_host_areas:
		area.active_target.connect(_on_enemy_active_target)
		area.unactive_target.connect(_on_enemy_unactive_target)


func load_characters() -> void:
	for i : Dictionary in host_data:
		var hsc_instance : Node = host_select_character_scene.instantiate()
		add_child(hsc_instance)
		hsc_instance.load_sprite(i["name"])
		# hsc_instance.quick_selected.connect(_on_quick_selected)
		## INFO: Removed quick select signal connection
		host_selects.append(hsc_instance)


func load_random_character() -> void:
	var hsc_instance : Node = host_select_character_scene.instantiate()
	add_child(hsc_instance)
	hsc_instance.load_sprite(random_character["name"])
	#hsc_instance.quick_selected.connect(_on_quick_selected)
	## INFO: Removed quick select signal connection
	host_selects.append(hsc_instance)


func _on_manually_selected(host : String, chosen_area : Node) -> void:
	### BUG: When you hover over already filled ones,
	### The 'preview' function in the host area replaces the already existing sprite 2d
	### Additionally, The last box of enemy hosta area isn't working for some reason
	var is_replacing : bool
	var is_player_area : bool = chosen_area in player_host_areas
	
	print(chosen_area.host_name)
	
	var relevant_areas : Array
	if is_player_area:
		relevant_areas = player_host_areas
	else:
		relevant_areas = enemy_host_areas
	#var relevant_areas : Array = is_player_area if player_host_areas else enemy_host_areas
	for i : Node in relevant_areas:
		if i.host_name == host:
			i.reset()
			print(host, " Removed. Moving to chosen position.")
			is_replacing = true
			break

	if host == "RANDOM":
		host = get_versus_random_host(is_player_area) # Has validation for duplicates

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


func _on_player_active_target(area : Node) -> void:
	print("Deactivating player host areas.")
	for i : Node in player_host_areas:
		if i != area:
			i.is_input_enabled = false


func _on_player_unactive_target() -> void:
	print("Reactivating player host areas.")
	for i : Node in player_host_areas:
		i.is_input_enabled = true


func _on_enemy_active_target(area : Node) -> void:
	print("Deactivating enemy host areas.")
	for i : Node in enemy_host_areas:
		if i != area:
			i.is_input_enabled = false


func _on_enemy_unactive_target() -> void:
	print("Reactivating enemy host areas.")
	for i : Node in enemy_host_areas:
		i.is_input_enabled = true


func _on_custom_rules_button_pressed() -> void:
	custom_select_menu.show()


func _on_start_button_pressed() -> void:
	for i : String in area_available:
		if area_available[i]["bool"]:
			print("Needs a full team!")
			if int(i) <= 3:
				print("Add more to player team!")
			else:
				print("Add more to enemy team!")
			return

	set_host_team()
	set_enemy_team()
	# Global.randomise_enemy: #DANGER: This is a shit holder, MUST CHANGE to ALL enemies, and have individual variance
	# TODO: Make randomising easier for players
	# Integrate this in the original host select menu and player_host area
	# Players that click on random in host area or drag from available list
	# Those players be able to individually set it.
	# TODO: Would double click be better than quick select?
	print("Moving to scene path...")
	Global.match_settings = custom_select_menu.match_settings
	hide()
	######### TODO: SEPARATE CustomSelectMenu and GameplayMapSelect to hide individually
	######### Make Gallery mode next
	versus_select.hide()
	custom_select_menu.hide()
	gameplay_map_select.show()
	# By default goes to level


func _on_reset_button_pressed() -> void:
	for i : Node in chosen_host_areas:
		i.reset()
		#print(i.get_children())
	for i : String in area_available:
		area_available[i]["bool"] = true

func _on_go_back() -> void:
	show()
	versus_select.show()
	gameplay_map_select.hide()


func get_versus_random_host(is_player_area : bool) -> String:
	var random_host : String
	while true:
		var randi : int = randi_range(0, host_names.size() - 1)
		random_host = host_names[randi]
		var temp : bool
		var area: String
		if is_player_area:
			area = "player"
			for i : Node in player_host_areas:
				if i.host_name == random_host:
					print("Random host %s already exists...Generating another host..." % random_host)
					temp = true
					break
		else:
			area = "enemy"
			for i : Node in enemy_host_areas:
				if i.host_name == random_host:
					print("Random host %s already exists...Generating another host..." % random_host)
					temp = true
					break
		if temp:
			continue
		print("Found host: %s not existent in %s area. Proceeding.." % [random_host, area])
		print("\n")
		break
	return random_host


func set_host_team() -> void:
	Global.player_team.clear()
	for i : Node in player_host_areas:
		Global.player_team.append(i.host_name)
	print("Player Team entered: %s." % [Global.player_team])


func set_enemy_team() -> void:
	Global.enemy_team.clear()
	for i : Node in enemy_host_areas:
		Global.enemy_team.append(i.host_name)
	print("Enemy team entered: %s." % [Global.enemy_team])
