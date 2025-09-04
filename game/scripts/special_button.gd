extends Button

var target : String
var table: Object
var effect_data : Dictionary
var value : float
var max_cooldown : float
var time : float

var max_value : bool = false
var current_cooldown: float = 0
var alive_host : bool = true

signal using_special
signal currently_served_customer
signal all_served_customers
signal customer_stream
signal current_host
signal player_team

func initalise(data: Dictionary, table_obj : Object) -> void:
	text = data.get("special_name")
	table = table_obj
	target = data.get("target")
	effect_data = data.get("effect_data")
	value = data.get("value", 0)
	max_cooldown = data.get("cooldown")
	time = data.get("time", 0)
	max_value = data.get("max_value", false)
	
	
func use_special() -> void:
	using_special.emit(text, target, effect_data, value, time, max_value, table)
	
	
func get_cooldown() -> int:
	return current_cooldown
	
	
func update_cooldown() -> void:
	current_cooldown = max_cooldown
	
	
func cooldown_check() -> bool:
	if current_cooldown == 0:
		return true
	return false
	
	
func alive_host_check() -> bool:
	if alive_host == true:
		return true
	else:
		return false
		
func _on_pressed() -> void:
	print("Attempting to use: ", text, " on Table ", table.get_table_id())
	use_special()
	
	
