extends Node2D

@export var gameplay_host_scene : PackedScene

var gameplay_hosts : Dictionary = {}

func load_gameplay_hosts(current_host_data: Array) -> void:
	for host_data: Dictionary in current_host_data:
		var gameplay_host_instance = gameplay_host_scene.instantiate()
		gameplay_host_instance.initalise(host_data)
		gameplay_hosts[host_data["name"]] = gameplay_host_instance
		add_child(gameplay_host_instance)


func get_host(host_name: String) -> GameplayHost:
	if gameplay_hosts.has(host_name):
		return gameplay_hosts[host_name]
	else:
		print("Host not found in gameplay: ", host_name)
		return null
		
		
func get_all_hosts() -> Dictionary:
	# Use when referencing
	return gameplay_hosts
	
	
func get_alive_hosts() -> Dictionary:
	var list_of_alive_hosts : Dictionary
	for host : Dictionary in gameplay_hosts:
		if host["current_stamina"] != 0:
			list_of_alive_hosts[host["name"]] = host
	return list_of_alive_hosts
	
	
