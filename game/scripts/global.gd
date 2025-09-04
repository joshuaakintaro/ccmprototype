extends Node

# DIRECTORIES
var host_selects_sprites_directory : String = "res://game/assets/sprites/host_selects/"

# PATHS
var visual_novel_path : String = "res://game/data/vn_scripts/test_visual_novel_script.json"
var host_select_path : String = "res://game/scene_managers/level_manager.tscn" #default goes to level_manager
var hosts_file_path : String = "res://game/data/hosts/test_hosts.json"
var save_file_path : String = "res://game/data/global/save_file.json"
var appearance_threshold_file_path : String = "res://game/data/global/APPEARANCE_THRESHOLDS.json"
var skill_file_path : String = "res://game/data/special/skills.json"
var abilities_file_path : String = "res://game/data/special/abilities.json"
var level_file_path : String = "res://game/data/level_data/test_levels.json"

# Constant dictionaries. DANGER: Stored in memory
var APPEARANCE_THRESHOLDS : Dictionary = Utils.parse_json_as_dict(appearance_threshold_file_path)
var SKILL_DATA : Dictionary = Utils.parse_json_as_dict(skill_file_path) #Assume it just works lmao
var ABILITY_DATA : Dictionary = Utils.parse_json_as_dict(abilities_file_path)
var LEVELS_DATA: Dictionary = Utils.parse_json_as_dict(level_file_path) #debug, assume its been interpreted

# Host values
var player_team : Array = ["Johnny", "Madeline", "Joanna"]
var enemy_team : Array = ["Johnny", "Boris", "Bessy"]

var checkpoint_check : Array = [false, 0]

# Online values
var online_match : String # Assigned online match type

# Match values
var current_map : String # WARNING: Must be assigned
var randomise_enemy : bool = true # Default
var match_settings : Dictionary

func save_scenario(data : Dictionary) -> void:
	var save_data : Dictionary = get_save_file()
	
	if not save_data.has("scenario"):
		save_data["scenario"] = {}

	save_data["scenario"][data["scenario_id"]] = data["scenario_data"]
	
	update_save_file(save_data)


func check_appearance_threshold(appearance_stat: Dictionary) -> Dictionary:
	# Check APPEARANCE_THRESHOLDS for values
	var threshold_check := {}
	for stat : String in appearance_stat.keys():
		var normalized_stat : String = stat.to_upper()  # Normalize key to uppercase
		if APPEARANCE_THRESHOLDS.has(normalized_stat):
			if appearance_stat[stat] > APPEARANCE_THRESHOLDS[normalized_stat]["max"]:
				threshold_check[stat] = "above max"
			elif appearance_stat[stat] > APPEARANCE_THRESHOLDS[normalized_stat]["ideal"]:
				threshold_check[stat] = "above ideal"
			else:
				threshold_check[stat] = "default"
		else:
			assert("Warning: Stat " + stat + " not found in thresholds!")
	return threshold_check


func random_team(side : String) -> void:
	var HOST_SAVE_DATA = Utils.parse_json_as_array(hosts_file_path)
	var team : Array
	
	enemy_team.clear()
	
	for i in 3:
		while true:
			var location : int = randi_range(0, (HOST_SAVE_DATA.size() - 1))
			var host_name : String = HOST_SAVE_DATA[location]["name"]
			var repeater : bool
			for k : String in team:
				if k == host_name:
					repeater = true

			if repeater:
				continue
			else:
				team.append(HOST_SAVE_DATA[location]["name"])
			break
	

	if side == "player":
		player_team = team
	if side == "enemy":
		enemy_team = team

	print("Randomised %s team %s!" % [side, team])

func random_vote(choice_keys: Array, choice_values: Array) -> String:
	if len(choice_keys) != len(choice_values):
		assert("Keys and weights must have the same length.")
		
	var key_votes: Array
	var counter: int = 0
	
	# Chosses a random key in a generated list of strings according to weight
	for i : int in len(choice_keys):
		for k : int in choice_values[i]:
			key_votes.append(choice_keys[i])
			counter += 1
	var key_winner := randi_range(0, (counter - 1))
	return key_votes[key_winner]


func _random_event_calculator(_total_chance: int) -> void:
	# TODO: Decide how chances from host and customer affect total likelihood
	# Call another function that decides which event
	# That will send a signal for that event to happen
	pass


func triangular(low: int, high: int, mode: int, spread: float = 1.0) -> int:
	if low > high:
		assert(false, "Lower bound is higher than upper bound.")
	if spread <= 0:
		assert(false, "Spread is less than or equal to zero")
	var u := randf()
	var c := (mode - low) / (high - low)
	
	if u > c:
		u = pow(u, 1.0 / spread)
		u = 1.0 - u
		c = 1.0 - c
		var temp := low
		low = high
		high = temp
	else:
		u = 1.0 - pow(1.0 - u, 1.0 / spread)
	return low + (high - low) * sqrt(u * c)

func get_save_file() -> Dictionary:
	var save_data : Dictionary = Utils.parse_json_as_dict(save_file_path)
	return save_data


func update_save_file(data : Dictionary) -> void:
	var file : FileAccess = FileAccess.open(save_file_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing: %s" % save_file_path)
		assert(false)
		return
	
	var json_string : String = JSON.stringify(data, "\t") #NOTE: REMOVE FOR RELEASE BUILDS
	file.store_string(json_string)
	file.close()
