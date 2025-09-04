extends CharacterBody2D

class_name Customer

#region attributes
#region constants
const DEMAND_CLAMP: int = 20
const HAPPINESS_CLAMP: int = 100
const PATIENCE_CLAMP : int = 100

const DEFAULT_BONUS : float = 1
const MATCHING_BONUS : float = 2
const NONMATCHING_PENALTY : float = 0.5

const BEST_HAPPINESS_TIER : int = 90
const BEST_HAPPINESS_TIER_HAPPINESS_BONUS : float = 2
const GOOD_HAPPINESS_TIER : int = 75
const GOOD_HAPPINESS_TIER_HAPPINESS_BONUS : float = 1.5
const DEFAULT_HAPPINESS_TIER : int = 50
const DEFAULT_HAPPINESS_TIER_HAPPINESS_BONUS : float = 1
const BAD_HAPPINESS_TIER : int = 25
const BAD_HAPPINESS_TIER_HAPPINESS_PENALTY : float = 0.5
### WORST_HAPPINESS_TIER is less than BAD_HAPPINESS_TIER_, apply penalty under 'else'
const WORST_HAPPINESS_TIER_HAPPINESS_PENALTY : float = 0

const BEST_HAPPINESS_TIER_SPENDING_FREQUENCY_BONUS : float = 0.5
const GOOD_HAPPINESS_TIER_SPENDING_FREQUENCY_BONUS : float = 0.75
const DEFAULT_HAPPINESS_TIER_SPENDING_FREQUENCY_BONUS : float = 1
const BAD_HAPPINESS_TIER_SPENDING_FREQUENCY_VALUE : float = 1.5
const WORST_HAPPINESS_TIER_SPENDING_FREQUENCY_VALUE : float = 2.0

const BEST_HAPPINESS_TIER_DEMAND_BONUS : float = 0.5
const GOOD_HAPPINESS_TIER_DEMAND_BONUS : float = 0.75
const DEFAULT_HAPPINESS_TIER_DEMAND_BONUS : float = 1
const BAD_HAPPINESS_TIER_DEMAND_PENALTY : float = 1.5
const WORST_HAPPINESS_TIER_DEMAND_PENALTY : float = 2.0

# Initial reputation is the most important
const BEST_HAPPINESS_TIER_REPUTATION_BONUS : int = 10
const GOOD_HAPPINESS_TIER_REPUTATION_BONUS : int = 5
const DEFAULT_HAPPINESS_TIER_REPUTATION_BONUS : int = 2
const BAD_HAPPINESS_TIER_REPUTATION_BONUS : int = -5
const WORST_HAPPINESS_TIER_REPUTATION_BONUS : int = -10

# 
const BEST_REPUTATION_TIER : int = 100
const BEST_REPUTATION_TIER_BONUS : float = 2
const GOOD_REPUTATION_TIER : int = 50
const GOOD_REPUTATION_TIER_BONUS : float = 1.5
const DEFAULT_REPUTATION_TIER : int = -50
const DEFAULT_REPUTATION_TIER_BONUS : float = 1.0
const BAD_REPUTATION_TIER : int = -100
const BAD_REPUTATION_TIER_PENALTY : float = 0.75
const WORST_REPUTATION_TIER : int = -100
const WORST_REPUTATION_TIER_PENALTY : float = 0.5

const FIRST_PATIENCE_TIER : int = 50
const FIRST_PATIENCE_TIER_PENALTY : float = 0.5
const SECOND_PATIENCE_TIER : int = 30
const SECOND_PATIENCE_TIER_PENALTY : float = 0.2
const LAST_PATIENCE_TIER : int = 20
const LAST_PATIENCE_TIER_PENALTY : float = 0.0

const REPUTATION_DEFAULT_APPEARANCE_BONUS = 20
const REPUTATION_ABOVE_IDEAL_APPEARANCE_BONUS = 10
const REPUTATION_MATCHING_APPEARANCE_BONUS = 40
const REPUTATION_NON_MATCHING_APPEARANCE_PENALTY = -50
#endregion constants

# Properties
var customer_id : int
var type: String
var stats: Dictionary
var preference: String
var temp_reputation : int
var using_max : Dictionary

# Sprite
var sprite: AnimatedSprite2D

# Physics & Shape
@onready var collision_shape_2d : Node = $CollisionShape2D
@onready var circle_shape_2d : Shape2D = $CollisionShape2D.get_shape()
@export var speed : int  # Speed of downward movement

var is_dragging: bool = false # Dragging state
var drag_offset: Vector2 = Vector2.ZERO
var last_position: Vector2 = Vector2.ZERO
var current_drop_zone = null # Track if the object is over a valid drop zone
var friction : float = 8.0  # Higher value = stronger friction
const  descent_speed : float = 100.0
var stop_threshold := 5.0  # below this speed, we'll stop sliding
# Signals
signal remove_customer
signal reputation_calculate

#endregion attributes
#region not gonna think about this
func set_shape(shape_size: float, shape_position: Vector2) -> void:
	circle_shape_2d.set_radius(shape_size)
	position = shape_position
	
	
func _process(delta) -> void:
	if is_dragging:
		position = get_global_mouse_position() + drag_offset
		
		
func _physics_process(delta) -> void:
	if not is_dragging:
		velocity.y = speed
		var collision := move_and_collide(velocity * delta)
		
		if collision:
			var normal := collision.get_normal()
			var slide_velocity := velocity.slide(normal)
			
			# Optionally allow gentle horizontal shift on bump
			slide_velocity.x = lerp(slide_velocity.x, 0.0, friction * delta)
			
			# Clamp small X motion
			if abs(slide_velocity.x) < stop_threshold:
				slide_velocity.x = 0
				
				
			velocity = slide_velocity
					
					
func _on_input_event(_viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_dragging and event.pressed: #draggin must be false and pres must be true
			start_dragging()
			
		if is_dragging and not event.pressed: #draggin must be true and press must be false
			stop_dragging()
			
			if current_drop_zone is Table:
				current_drop_zone.get_body_data(customer_id)  # Send data to the Area2D
				current_drop_zone = null  # Reset the reference
				get_parent().remove_child(self)
				
			elif current_drop_zone is CustomerArea or current_drop_zone is Customer:
				position = get_global_mouse_position()
				
			else:
				position = last_position
				
				
func start_dragging() -> void:
	set_collision_layer(2)
	set_collision_mask(2)
	last_position = position
	is_dragging = true
	get_viewport().set_input_as_handled()
	
	
func stop_dragging() -> void:
	set_collision_layer(1)
	set_collision_mask(1)
	is_dragging = false
	get_viewport().set_input_as_handled()
	
	
func initalise(id: int, data: Dictionary) -> void:
	customer_id = id
	type = data.get("type")
	preference = data.get("preference")
	stats = data.get("stats")
	temp_reputation = stats["reputation"]
	
	
func apply_special(special_name : String, effect_data : Dictionary, value : float, time: float, max_value : bool) -> void:
	set_stat(effect_data["stat"], value, max_value, false)
	print("Applied: ", special_name)
	if time == 0:
		print("Permanent Customer Effect: ", special_name)
	else:
		print("Added Timer for Customer Effect: ", special_name)
		var timer = Timer.new()
		add_child(timer)
		timer.start(time)
		await timer.timeout
		set_stat(effect_data["stat"], value, max_value, true)
		print("Effect Timeout: ", special_name)
		
		
func initial_impressions(appearance_stats: Dictionary) -> void:
	var threshold_checks : Dictionary = Global.check_appearance_threshold(appearance_stats)
	for appearance in threshold_checks:
		if appearance.keys() == preference:
			matching_appearance_bonus(appearance_stats[appearance].values())
		elif appearance.values() == "above max":
			non_matching_appearance_penalty(appearance_stats[appearance].values())
		elif appearance.values() == "above ideal":
			default_appearance_bonus(appearance_stats[appearance].values())
		elif appearance.values() == "default":
			default_appearance_bonus(appearance_stats[appearance].values())
			
			
func current_impressions(performance_stats: Dictionary) -> void:
	charm_bonus(performance_stats["charm"])
	empathy_bonus(performance_stats["empathy"])
	check_patience()
	calculate_happiness_bonus()
	update_spending_rate()
	update_demand()
	
	
func default_appearance_bonus(appearance: int) -> void:
	stats["happiness"] += appearance * DEFAULT_BONUS
	temp_reputation += REPUTATION_DEFAULT_APPEARANCE_BONUS
	
	
func above_ideal_appearance_bonus(appearance: int) -> void: 
	stats["happiness"] += appearance * 0.5
	# TODO: Change this to offer less but still significant benefits
	temp_reputation += REPUTATION_ABOVE_IDEAL_APPEARANCE_BONUS
	
	
func matching_appearance_bonus(appearance: int) -> void:
	stats["happiness"] += appearance * MATCHING_BONUS
	#TODO: Change for balancing
	temp_reputation += REPUTATION_MATCHING_APPEARANCE_BONUS
	
	
func non_matching_appearance_penalty(appearance: int) -> void:
	stats["happiness"] -= appearance * NONMATCHING_PENALTY
	temp_reputation += REPUTATION_NON_MATCHING_APPEARANCE_PENALTY
	
	
func calculate_spending() -> int:
	var spending : int = stats["spending"] * calculate_happiness_bonus()
	return spending
	
	
func calculate_happiness_bonus() -> int:
	var current_happiness : int = stats["happiness"]
	if current_happiness > BEST_HAPPINESS_TIER:
		return BEST_HAPPINESS_TIER_HAPPINESS_BONUS
	elif current_happiness > GOOD_HAPPINESS_TIER:
		return GOOD_HAPPINESS_TIER_HAPPINESS_BONUS
	elif current_happiness > DEFAULT_HAPPINESS_TIER:
		return DEFAULT_HAPPINESS_TIER_HAPPINESS_BONUS
	elif current_happiness > BAD_HAPPINESS_TIER:
		return BAD_HAPPINESS_TIER_HAPPINESS_PENALTY
	else:
		return WORST_HAPPINESS_TIER_HAPPINESS_PENALTY
		
		
func check_patience() -> void:
	# Storing variable to prevent other functions from interfering
	var current_patience = stats["patience"]
	if current_patience < LAST_PATIENCE_TIER:
		stats["happiness"] *= LAST_PATIENCE_TIER_PENALTY
	elif current_patience < SECOND_PATIENCE_TIER:
		stats["happiness"] *= SECOND_PATIENCE_TIER_PENALTY
	elif current_patience < FIRST_PATIENCE_TIER:
		stats["happiness"] *= FIRST_PATIENCE_TIER_PENALTY
		
		
func check_reputation() -> void:
	# Storing variable to prevent other functions from interfering
	var reputation : int = stats["reputation"]
	if reputation > BEST_REPUTATION_TIER:
		stats["happiness"] *= BEST_REPUTATION_TIER_BONUS
	elif reputation > GOOD_REPUTATION_TIER:
		stats["happiness"] *= GOOD_REPUTATION_TIER_BONUS
	elif reputation > DEFAULT_REPUTATION_TIER:
		stats["happiness"] *= DEFAULT_REPUTATION_TIER_BONUS
	elif reputation > BAD_REPUTATION_TIER:
		stats["happiness"] *= BAD_REPUTATION_TIER_PENALTY
	elif reputation <= WORST_REPUTATION_TIER:
		stats["happiness"] *= WORST_REPUTATION_TIER_PENALTY
		
		
func charm_bonus(value: int) -> void:
	stats["happiness"] += value
	
	
func empathy_bonus(value: int) -> void:
	stats["patience"] += value
	
	
func update_spending_rate() -> void:
	if stats["happiness"] > BEST_HAPPINESS_TIER:
		stats["spending_frequency"] *= BEST_HAPPINESS_TIER_SPENDING_FREQUENCY_BONUS
	elif stats["happiness"] > GOOD_HAPPINESS_TIER:
		stats["spending_frequency"] *= GOOD_HAPPINESS_TIER_SPENDING_FREQUENCY_BONUS
	elif stats["happiness"] > DEFAULT_HAPPINESS_TIER:
		stats["spending_frequency"] *= DEFAULT_HAPPINESS_TIER_SPENDING_FREQUENCY_BONUS
	elif stats["happiness"] > BAD_HAPPINESS_TIER:
		stats["spending_frequency"] = BAD_HAPPINESS_TIER_SPENDING_FREQUENCY_VALUE
	else:
		stats["spending_frequency"] = WORST_HAPPINESS_TIER_SPENDING_FREQUENCY_VALUE
		
		
func update_demand() -> void:
	if stats["happiness"] > BEST_HAPPINESS_TIER:
		stats["physical_demand"] *= BEST_HAPPINESS_TIER_DEMAND_BONUS
		stats["emotional_demand"] *= BEST_HAPPINESS_TIER_DEMAND_BONUS
	elif stats["happiness"] > GOOD_HAPPINESS_TIER:
		stats["physical_demand"] *= GOOD_HAPPINESS_TIER_DEMAND_BONUS
		stats["emotional_demand"] *= GOOD_HAPPINESS_TIER_DEMAND_BONUS
	elif stats["happiness"] > DEFAULT_HAPPINESS_TIER:
		stats["physical_demand"] *= DEFAULT_HAPPINESS_TIER_DEMAND_BONUS
		stats["emotional_demand"] *= DEFAULT_HAPPINESS_TIER_DEMAND_BONUS
	elif stats["happiness"] > BAD_HAPPINESS_TIER:
		stats["physical_demand"] *= BAD_HAPPINESS_TIER_DEMAND_PENALTY
		stats["emotional_demand"] *= BAD_HAPPINESS_TIER_DEMAND_PENALTY
	else:
		stats["physical_demand"] *= WORST_HAPPINESS_TIER_DEMAND_PENALTY
		stats["emotional_demand"] *= WORST_HAPPINESS_TIER_DEMAND_PENALTY
		
		
func update_reputation() -> void:
	if stats["happiness"] > BEST_HAPPINESS_TIER:
		temp_reputation += BEST_HAPPINESS_TIER_REPUTATION_BONUS
	elif stats["happiness"] > GOOD_HAPPINESS_TIER:
		temp_reputation += GOOD_HAPPINESS_TIER_REPUTATION_BONUS
	elif stats["happiness"] > DEFAULT_HAPPINESS_TIER:
		temp_reputation += DEFAULT_HAPPINESS_TIER_REPUTATION_BONUS
	elif stats["happiness"] > BAD_HAPPINESS_TIER:
		temp_reputation += BAD_HAPPINESS_TIER_REPUTATION_BONUS
	else:
		temp_reputation += WORST_HAPPINESS_TIER_REPUTATION_BONUS
		
		
func event_trigger() -> void:
	# INFO: Signal gets emitted from level, allowing for events to play out based on random chance
	# Would decide on whether to give good or bad events, their own functions which call
	# \ on other functions here
	pass
	
	
func get_type() -> String:
	return type
	
	
func get_preference() -> String:
	return preference
	
	
func get_stats() -> Dictionary:
	return stats
	
	
func get_current_demand() -> Dictionary:
	stats["physical_demand"] = clamp(stats["physical_demand"] + stats["happiness"], DEMAND_CLAMP, 1000)
	stats["emotional_demand"] = clamp(stats["emotional_demand"] + stats["happiness"], DEMAND_CLAMP, 1000)
	var demand_dictionary = {"physical_demand" : stats["physical_demand"], "emotional_demand" : stats["emotional_demand"] }
	return demand_dictionary
	
	
func get_calculated_reputation() -> int:
	return temp_reputation
	
	
func set_stat(effecting_stat: String, value: float, max_value: bool, reverse_effect : bool) -> void:
	if max_value:
		#WARNING: Possible to fuck things up with repeated same skill use
		#TODO: Fix with if stat in using_max
		match effecting_stat:
			"physical_demand":
				set_min_demand("physical_demand", reverse_effect)
			"emotional_demand":
				set_min_demand("emotional_demand", reverse_effect)
			"total_demand":
				set_min_total_demand(reverse_effect)
			"happiness":
				set_max_happiness(reverse_effect)
	else:
		if effecting_stat in stats:
			if reverse_effect:
				if effecting_stat in using_max:
					using_max[effecting_stat] *= value
				else:
					stats[effecting_stat] *= value
			else:
				if effecting_stat in using_max:
					using_max[effecting_stat] /= value
				else:
					stats[effecting_stat] /= value
				
				
func set_max_happiness(reverse_effect : bool) -> void:
	if reverse_effect:
		stats["happiness"] = using_max["happiness"]
		if "patience" in using_max and stats["patience"] == PATIENCE_CLAMP:
			stats["patience"] = using_max["patience"]
			using_max.erase("patience")
		using_max.erase("happiness")
	else:
		using_max["happiness"] = stats["happiness"]
		if not "patience" in using_max:
			using_max["patience"] = stats["patience"]
			stats["patience"] = PATIENCE_CLAMP
		stats["happiness"] = HAPPINESS_CLAMP
	
	
func set_min_demand(effected_demand : String, reverse_effect : bool) -> void:
	if reverse_effect:
		stats[effected_demand] = using_max[effected_demand]
		using_max.erase(effected_demand)
	else:
		using_max[effected_demand] = stats[effected_demand]
		stats[effected_demand] = 0
		
		
func set_min_total_demand(reverse_effect : bool) -> void:
	set_min_demand("physical_demand", reverse_effect)
	set_min_demand("emotional_demand", reverse_effect)
	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Customer ID: ", customer_id, " exited.")
	remove_customer.emit(customer_id, circle_shape_2d.radius, position)
	reputation_calculate.emit(get_calculated_reputation(), type)
	queue_free()
	
	
#endregion
