extends BaseHost

class_name GameplayHost 

var current_status : Dictionary
var alive : bool = true
var using_max : Dictionary = {}

func initalise(data: Dictionary) -> void:
	host_name = data.get("name")
	appearance = data.get("appearance")
	status = data.get("status")
	current_status = status
	performance = data.get("performance")
	special = data.get("special")
	
	
func update_status(demand_dictionary: Dictionary) -> void:
	update_stamina(demand_dictionary["physical_demand"])
	update_mood(demand_dictionary["emotional_demand"])
	
	
func update_stamina(value: int) -> void:
	value = abs(value)
	current_status["stamina"] += value
	if current_status["stamina"] < 0:
		current_status["stamina"] = 0
	
	
func update_mood(value: int) -> void:
	value = abs(value)
	current_status["mood"] -= value
	if current_status["mood"] < 0:
		current_status["mood"] = 0
	
	
func reset_status(stat : String) -> void:
	current_status[stat] = status[stat]
	
	
func half_stamina_check() -> bool:
	if current_status["stamina"] <= status["stamina"] / 2:
		return true
	else:
		return false
		
		
func half_mood_check() -> bool:
	if current_status["mood"] <= status["mood"] / 2:
		return true
	else:
		return false
		
		
func zero_stamina_check() -> bool:
	if current_status["stamina"] == 0:
		return true
	else:
		return false
		
		
func zero_mood_check() -> bool:
	if current_status["mood"] == 0:
		return true
	else:
		return false
		
		
func set_stat(big_stat: String, sub_stat: String, value: float, time: float, max_value : bool, reverse_effect : bool) -> void:
	if max_value:
		if time == 0:
			match big_stat:
				"status":
					set_status(sub_stat, value, reverse_effect)
				"appearance":
					set_appearance(sub_stat, value, reverse_effect)
				"performance":
					set_performance(sub_stat, value, reverse_effect)
		else:
			match big_stat:
				"status":
					set_max_status(sub_stat, reverse_effect)
				_:
					assert("Big error!")
	else:
		match big_stat:
			"status":
				set_status(sub_stat, value, reverse_effect)
			"appearance":
				set_appearance(sub_stat, value, reverse_effect)
			"performance":
				set_performance(sub_stat, value, reverse_effect)
				
				
func set_status(stat: String, value: float, reverse_effect : bool) -> void:
	if reverse_effect:
		if stat in using_max:
			using_max[stat] /= value
		else:
			current_status[stat] /= value
	else:
		if stat in using_max:
			using_max[stat] *= value
		else:
			current_status[stat] *= value
		
		
func set_appearance(stat: String, value: float, reverse_effect : bool) -> void:
	if reverse_effect:
		appearance[stat] /= value
	else:
		appearance[stat] *= value
		
		
func set_performance(stat: String, value: float, reverse_effect : bool) -> void:
	if reverse_effect:
		if stat in using_max:
			using_max[stat] /= value
		else:
			performance[stat] /= value
	else:
		if stat in using_max:
			using_max[stat] *= value
		else:
			performance[stat] *= value
		
		
func set_max_status(stat: String, reverse_effect : bool) -> void:
	if reverse_effect:
		current_status[stat] = using_max[stat]
		using_max.erase(stat)
		
		
	else:
		if stat in using_max:
			pass
		else:
			using_max[stat] = current_status[stat]
			reset_status(stat)
			
			
