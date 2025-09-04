extends Node2D

@onready var customer_area : Node = $CustomerArea
@onready var customer_gate : Node = $CustomerGate
@onready var customer_wall_1 : Node = $CustomerWall1
@onready var customer_wall_2 : Node = $CustomerWall2
@onready var customer_top : Node = $CustomerTop
@onready var customer_area_rect = $CustomerArea/CollisionShape2D.get_shape().get_rect()
@onready var customer_shape_radius : float = (customer_area_rect.size.x / 9)
@onready var customer_area_position = $CustomerArea/CollisionShape2D.position
@onready var TYPE_DEFAULTS = load_type_defaults()
@onready var spawn_positions : Array = calculate_spawn_positions()

@export var customer_instance : PackedScene
@export var customer_spawn_area_instance: PackedScene
@export var customer_placeholder_instance : PackedScene
@export var extra_height : int

var spawn_areas : Array
var max_customers : int = 4 # Max customers in a row

const TYPES_FILE = "res://game/data/customer_data/customer_types.json"
var current_id : int = 0
var customers := {}

signal customer_manager_reputation_calculate


func _ready():
	customer_area.extra_height = extra_height
	customer_wall_1.extra_height = extra_height
	customer_wall_2.extra_height = extra_height
	customer_top.extra_height = extra_height
	customer_gate.set_shape(customer_area.get_size(), customer_area.get_position())
	customer_wall_1.set_shape(customer_area.get_size(), customer_area.get_position())
	customer_wall_2.set_shape(customer_area.get_size(), customer_area.get_position())
	customer_top.set_shape(customer_area.get_size(), customer_area.get_position())
	set_customer_spawn_area()
	
	
func load_type_defaults() -> Dictionary:
	var raw_data: Dictionary = Utils.parse_json_as_dict(TYPES_FILE)
	var default_data : Dictionary = {}
	for type_data: String in raw_data["types"]:
		default_data[type_data] = raw_data["types"][type_data]
	print("Loaded default types", default_data.keys())
	return default_data
	
	
func set_type_stat(type: String, stat : String, value: int) -> void:
	TYPE_DEFAULTS[type]["stats"][stat]["range"] = [value - 5, value + 5]
	
	
func set_customer_spawn_area() -> void:
	for i in 4:
		var customer_spawn_area: Node2D = customer_spawn_area_instance.instantiate()
		add_child(customer_spawn_area)
		customer_spawn_area.set_shape(customer_shape_radius, spawn_positions[i])
		spawn_areas.append(customer_spawn_area)
		
		
func spawn_customer(customer_bias_data: Dictionary) -> void:
	for i in spawn_areas.size():
		if not (spawn_areas[i].is_occupied): # checks spawn_area_instance
			customers[current_id] = customer_instance.instantiate()
			var customer_data = generate_customer_data(customer_bias_data)
			add_child(customers[current_id])
			customers[current_id].initalise(current_id, customer_data)
			customers[current_id].set_shape(customer_shape_radius, spawn_positions[i])
			customers[current_id].remove_customer.connect(_on_removed_customer)
			customers[current_id].reputation_calculate.connect(_on_reputation_calculated)
			increment_customer_id()
			
			
func generate_customer_data(customer_bias_data: Dictionary) -> Dictionary:
	var chosen_type : String = select_type(customer_bias_data["type_bias"])
	var stat_data: Dictionary = {"type" : chosen_type, "preference" : "","stats" : {}}
	stat_data["preference"] = TYPE_DEFAULTS[chosen_type]["preference"]
	for stat_key : String in ["physical_demand", "emotional_demand", "happiness", "reputation", "patience", "order_duration", "spending", "spending_frequency", "troublemaking"]:
		stat_data["stats"][stat_key] = generate_stat(TYPE_DEFAULTS[chosen_type]["stats"][stat_key])
	return stat_data
	
	
func select_type(type_bias: Dictionary) -> String:
	var type_keys: Array = type_bias.keys()
	var type_weights: Array = type_bias.values()
	return Global.random_vote(type_keys, type_weights)
	
	
func generate_stat(defaults: Dictionary) -> int:
	var range_bound: Array = defaults.get("range")
	return randi_range(range_bound[0],range_bound[1])
	
	
func increment_customer_id() -> void:
	current_id += 1
	
	
func get_customer(cutomer_id: int) -> Customer:
	if customers.has(cutomer_id):
		return customers[cutomer_id]
	else:
		print("Customer with ID not found: ", cutomer_id)
		return null
		
		
func calculate_spawn_positions() -> Array:
	var spacing = customer_area_rect.size.x / max_customers
	var spawn_positions : Array = []
	for i in range(max_customers):
		var position_x = customer_area.position.x - (customer_area_rect.size.x / 2) + (i * spacing) + (spacing / 2)
		var position_y = customer_area.position.y - (customer_area_rect.size.y / 2)
		spawn_positions.append(Vector2(position_x, position_y - extra_height))
	return spawn_positions
	
	
func calculate_random_spawn_positions() -> Vector2:
	var spacing = customer_area_rect.size.x / max_customers
	var position_x = customer_area.position.x - (customer_area_rect.size.x / 2) + (randf_range(0,4) * spacing) + (spacing / 2)
	var position_y = customer_area.position.y - (customer_area_rect.size.y / 2)
	return Vector2i(position_x, position_y)
	
	
func _on_removed_customer(customer_id : int, radius : float, shape_position : Vector2) -> void:
	customers.erase(customer_id)
	var customer_placeholder : Node = customer_placeholder_instance.instantiate()
	customer_placeholder.set_shape(radius, shape_position)
	add_child(customer_placeholder)
	
	
func _on_reputation_calculated(reputation: int, type: String) -> void:
	customer_manager_reputation_calculate.emit(reputation, type)
	
	
