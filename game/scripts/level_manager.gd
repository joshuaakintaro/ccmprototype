extends Node2D
#Manages things surrounding the level, sending signals for computation by GameplayHost & Customer
var original_value : int
var original_values : Array


func event_chances(host_name: String, customer_id: int) -> void:
	var host_chance : int = (($GameplayHostManager.get_host(host_name)).get_current_performance()).get("luck")
	var customer_chance : int = (($CustomerManager.get_customer(customer_id)).get_stats()).get("luck")
	var total_chance := host_chance + customer_chance
	$Global.random_event_calculator(total_chance)
	# Sends signal for some other function to create an event
	
	
func _on_use_special(root_host : GameplayHost, host_special_data : Dictionary, table: Table) -> void:
	match host_special_data["target"]:
		"single_customer":
			if "time" in host_special_data.keys():
				original_value = get_customer_original_value(table.get_customer(), host_special_data)
			apply_special_to_customer(table.get_customer(), host_special_data)
			
		"all_customers":
			if "time" in host_special_data.keys():
				for customers in $CustomerManager.get_all_customers():
					original_values[customers]= get_customer_original_value(table.get_customer(), host_special_data)
			for customers in $CustomerManager.get_all_customers():
				apply_special_to_customer(table.get_customer(), host_special_data)
				
		"single_host":
			if "time" in host_special_data.keys():
				original_value = get_host_original_value(root_host, host_special_data)
			apply_special_to_host(root_host, host_special_data)
			
		"all|_hosts":
			if "time" in host_special_data.keys():
				for host in $GameplayHostManager.get_all_hosts():
					original_value = get_host_original_value(host, host_special_data)
			for host in $GameplayHostManager.get_all_hosts():
				apply_special_to_host(host, host_special_data)
				
				
func apply_special_to_customer(customer: Customer, special_data: Dictionary) -> void:
	customer["stats"][special_data["stat"]] *= special_data["value"]
	
	
func apply_special_to_host(host: GameplayHost, special_data: Dictionary) -> void:
	if special_data["stat"] in host["appearance"]:
		host["appearance"][special_data["stat"]] *= special_data["value"]
	if special_data["stat"] in host["performance"]:
		host["performance"][special_data["stat"]] *= special_data["value"]
	
	
func get_customer_original_value(customer: Customer, special_data: Dictionary) -> int:
	return customer["stats"][special_data["stat"]]
	
	
func get_host_original_value(host: GameplayHost, special_data: Dictionary) -> int:
	if special_data["stat"] in host["appearance"]:
		return host["appearance"][special_data["stat"]]
	if special_data["stat"] in host["performance"]:
		return host["performance"][special_data["stat"]]
	else:
		assert("Can't find host original value")
		return 1
		
