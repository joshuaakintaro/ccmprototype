extends Node2D

#region attributes
@onready var customer_manager : Node = $CustomerManager
@onready var customer_area : Node = $CustomerManager/CustomerArea
@onready var customer_wall_1 : Node = $CustomerManager/CustomerWall1
@onready var customer_wall_2 : Node = $CustomerManager/CustomerWall2

@onready var table_manager : Node = $TableManager
@onready var gameplay_host_manager : Node = $TableManager/GameplayHostManager

@onready var level_ui_manager = $LevelUIManager
@onready var top_ui = $LevelUIManager/TopUI
@onready var player_money_container = $LevelUIManager/TopUI/MoneyContainer
@onready var enemy_money_container = $LevelUIManager/TopUI/MoneyContainer2
@onready var round_timer_label : Node = $LevelUIManager/TopUI/RoundTimerContainer/RoundTimerLabel
@onready var special_buttons : Array = get_tree().get_nodes_in_group("special_button_containers")
@onready var level_data : Dictionary = load_level_data(DEBUG_LEVEL)

const DEBUG_LEVEL : String = "1"
const ROUND_TIME : int = 10 # Normal value will be 30
const CUSTOMER_SPAWNING_TIME : float = 1

var host_special_data : Array

var table_positions : Array
var table_size : Vector2

var spawn_customer_condition : bool = false
var storage_dictionary : Dictionary
var player_win_count : int = 0
var opponent_win_count : int = 0
var round_count : int = 1

var player_team : Array
var enemy_team : Array

var randomise_enemy : bool = true #On by default

#endregion attributes
func _ready() -> void:
	customer_manager.customer_manager_reputation_calculate.connect(_on_customer_reputation_calculated)
	main()


func load_teams() -> void:
	var player_hosts : Array = Global.player_team
	var SAVED_HOST_DATA = Utils.parse_json_as_array("res://game/data/hosts/test_hosts.json")
	
	for host : String in player_hosts:
		for i : Dictionary in SAVED_HOST_DATA:
			if i["name"] == host:
				player_team.append(i)

	var enemy_hosts : Array = Global.enemy_team
	for host : String in enemy_hosts:
		for i : Dictionary in SAVED_HOST_DATA:
			if i["name"] == host:
				enemy_team.append(i)


func main() -> void:
	load_level()
	start_round()


func load_level() -> void:
	load_teams()
	load_gameplay_host_data()
	load_tables()
	load_host_special_data()
	load_player_data()
	print(calculate_table_layouts())
	
func start_round():
	$RoundTimer.start(1.0) # Check timeout
	round_timer_label.round_ended.connect(_on_round_ended)
	spawn_customer_condition = true
	$CustomerSpawningTimer.start(CUSTOMER_SPAWNING_TIME)
	
	
func _on_round_ended() -> void:
	spawn_customer_condition = false
	$CustomerSpawningTimer.stop()
	$RoundTimer.stop()
	compare_total_money()
	store_reputation()
	
	
func compare_total_money() -> void:
	var money_containers : Array = level_ui_manager.get_money_containers()
	if money_containers[0].get_money() > money_containers[1].get_money():
		print("Player wins!")
		player_win_count += 1
	elif money_containers[1].get_money() > money_containers[0].get_money():
		print("Opponent wins!")
		opponent_win_count += 1
	else:
		print("Draw!")
		player_win_count += 1
		opponent_win_count += 1
	round_count +=1
	
func store_reputation() -> void:
	for type : String in storage_dictionary.keys():
		var reputation_average = storage_dictionary[type]["reputation_tally"] / storage_dictionary[type]["total"]
		customer_manager.set_type_stat(type, "reputation", reputation_average)
		print("Function worked!")
		
		
func _on_customer_reputation_calculated(reputation : int, type: String) -> void:
	storage_dictionary[type]["reputation_tally"] += reputation
	storage_dictionary[type]["total"] += 1
	
	
func load_level_data(level_name: String) -> Dictionary:
	if level_name in Global.LEVELS_DATA["level"]:
		for type : String in Global.LEVELS_DATA["level"][level_name]["type_bias"].keys():
			var temp : Dictionary
			temp["reputation_tally"] = 0
			temp["total"] = 0
			storage_dictionary[type] = temp
			
			
		return Global.LEVELS_DATA["level"][level_name]
	else:
		assert("Unable to find level.")
		return {}
		
		
func load_gameplay_host_data() -> void:
	# INFO: In case of temporary hosts in team, pass specifically instead of using save file
	gameplay_host_manager.load_gameplay_hosts(player_team)
	gameplay_host_manager.load_gameplay_hosts(enemy_team)
	var host_array : Array = gameplay_host_manager.get_all_hosts().keys()
	print("Loaded gameplay hosts: %s" % [host_array])
		
		

func calculate_table_layouts() -> Dictionary:
	var screen_size: Vector2i = get_viewport().get_visible_rect().size
	var top_ui_bottom: float = level_ui_manager.top_ui.size.y
	var host_status_top: float = screen_size.y - level_ui_manager.host_status_box.size.y
	var section_width: int = screen_size.x / 5

	# Player table region: from top_ui.bottom to full screen bottom
	var player_area_top = top_ui_bottom
	var player_area_bottom = screen_size.y
	var player_area_height = player_area_bottom - player_area_top
	var player_table_height = player_area_height / 3
	var player_table_width = section_width * 2

	# Opponent table region: from top_ui.bottom to host_status.top (compressed space)
	var opponent_area_top = top_ui_bottom
	var opponent_area_bottom = host_status_top
	var opponent_area_height = opponent_area_bottom - opponent_area_top
	var opponent_table_height = opponent_area_height / 3
	var opponent_table_width = section_width * 2

	var result = {
		"player_tables": [],
		"opponent_tables": []
	}

	# Player tables
	for i in range(3):
		var pos = Vector2(0, player_area_top + i * player_table_height)
		var size = Vector2(player_table_width, player_table_height)
		result["player_tables"].append({"position": pos, "size": size})

	# Opponent tables (vertically centred and compressed)
	for i in range(3):
		var pos = Vector2(section_width * 3, opponent_area_top + i * opponent_table_height)
		var size = Vector2(opponent_table_width, opponent_table_height)
		result["opponent_tables"].append({"position": pos, "size": size})

	return result



func load_tables():
	table_manager.load_table_data(player_team, enemy_team)
	
	var table_layouts : Dictionary = calculate_table_layouts()
	var counter : int = 0
	
	for player_table : Object in table_manager.player_tables.values():
		#DANGER: "Invalid access of index '3' on a base object of type: 'Array'.", most likely caused by counter
		## But why is @constainer_pos have 6 values in it?
		player_table.player_assigned_customer.connect(_on_table_assigned_customer)
		player_table.send_spending.connect(_on_customer_spending)
		player_table.table_customer_reputation_calculate.connect(_on_customer_reputation_calculated)
		player_table.position = table_layouts["player_tables"][counter]["position"] + table_layouts["player_tables"][counter]["size"] * 0.5
		player_table.rectangle_shape_2d.set_size(table_layouts["player_tables"][counter]["size"])
		#player_table.set_texture()
		counter += 1

	counter = 0
	
	for enemy_table : Object in table_manager.enemy_tables.values():
		enemy_table.player_assigned_customer.connect(_on_table_assigned_customer)
		enemy_table.send_spending.connect(_on_customer_spending)
		enemy_table.table_customer_reputation_calculate.connect(_on_customer_reputation_calculated)
		enemy_table.position = table_layouts["opponent_tables"][counter]["position"] + table_layouts["opponent_tables"][counter]["size"] * 0.5
		enemy_table.rectangle_shape_2d.set_size(table_layouts["opponent_tables"][counter]["size"])
		#enemy_table.set_texture()
		counter += 1
	"""
	var screen_size: Vector2i = get_viewport().get_visible_rect().size
	var host_status_top: float = screen_size.y - level_ui_manager.host_status_box.size.y
	for money_container : Node in level_ui_manager.get_money_containers():
		money_container.set_texture(Vector2i(500, 64))
		"""
		
func load_host_special_data() -> void:
	for table : Object in table_manager.tables.values():
		var special_ids : Dictionary = table.get_host().get_special()
		host_special_data.append(load_host_special(special_ids["skill_id"], special_ids["ability_id"]))
		host_special_data[-1]["table"] = table
	load_special_button_data()
	print(get_tree().get_nodes_in_group("special_button_containers"))
		
		
func load_player_data() -> void:
	var top_ui_bottom_left : Vector2 = Utils.get_shape_point(top_ui.get_position(), top_ui.get_size(), "bottom_left")
	var customer_wall_1_position_x : float = customer_wall_1.segment_2d.get_rect().position.x
	
	
	var image_size : Vector2i = Vector2i(customer_wall_1_position_x, top_ui_bottom_left.y)
	level_ui_manager.set_healthbar_textures(image_size)
	
func load_special_button_data() -> void:
	for i : int in 3:
		special_buttons[i].load_special_buttons(host_special_data[i])
		special_buttons[i].special_activation.connect(_on_special_activation)
	
	
func load_host_special(skill_id: String, ability_id: String) -> Dictionary:
	var special_data : Dictionary
	special_data["skill"] = load_skill_data(skill_id, Global.SKILL_DATA)
	special_data["ability"] = load_ability_data(ability_id, Global.ABILITY_DATA)
	return special_data
	
	
func load_skill_data(skill_id: String, data_source: Dictionary) -> Dictionary:
	if skill_id in data_source["skill"]:
		var skill : Dictionary = data_source["skill"][skill_id]
		return skill
	else:
		assert("Can't find data for specified skill id: ", skill_id)
		return {}
		
		
func load_ability_data(ability_id: String, data_source: Dictionary) -> Dictionary:
	if ability_id in data_source["ability"]:
		return data_source["ability"][ability_id]
	else:
		assert(false, "Can't find data for specified ability_id")
		return {}
		
		
func _on_customer_spawning_timer_timeout() -> void:
	customer_manager.spawn_customer(level_data)
	
	
func _on_round_timer_timeout() -> void:
	round_timer_label.update_time()
	
	
func _on_special_usage() -> void:
	pass
	
	
func _on_table_assigned_customer(table_id: int, customer_id: int) -> void:
	# Need to refer to the proper table
	var customer_data = customer_manager.get_customer(customer_id)
	table_manager.tables[table_id].assign_customer(customer_data)
	print("Table ID: ", table_id, " With Customer ID: ",customer_id)
	
	
func _on_customer_spending(spending_amount: int, host_name : String) -> void:
	player_money_container.player_money_label.add_money(spending_amount)
	## TODO: Use name to keep account of an MVP host
	
	
func _on_special_activation(special_name : String, target: String, effect_data : Dictionary, value : float, time : float, max_value : bool, table : Object) -> void:
	match target:
		"host":
			table.apply_special_on_host(special_name, effect_data, value, time, max_value)
			print("ran")
		"customer":
			table.apply_special_on_customer(special_name, effect_data, value, time, max_value)
		"team":
			for all_tables : Object in table_manager.tables.values():
				all_tables.apply_special_on_host(special_name, effect_data, value, time, max_value)
		"all_served_customers":
			for all_tables : Object in table_manager.tables.values():
				all_tables.apply_special_on_customer(special_name, effect_data, value, time, max_value)
		"customer_stream":
			pass
			for all_customers : Object in customer_manager.customers.values():
				all_customers.apply_special(special_name, effect_data, value, time, max_value)
				print("ran2222")
		"enemy":
			pass
			
			
