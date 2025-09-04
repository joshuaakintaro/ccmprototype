extends Node2D

class_name BaseHostManager

const BASE_HOST_SCENE = preload("res://base_host.tscn")
const DEFAULT_HOST_FILE = "res://Data/DEFAULT_HOSTS.json"
const HOST_SAVE_FILE = "res://Data/HostSaveFile.json" # Make function to load saved hosts
var hosts := {}


func load_default_hosts() -> void:
	var raw_data: Array = Global.readJSON(DEFAULT_HOST_FILE)
	for host_data: Dictionary in raw_data:
		var host_instance : Node2D = BASE_HOST_SCENE.instantiate()
		host_instance.init(host_data)
		hosts[host_data["name"]] = host_instance
	print("Loaded default hosts: ", hosts.keys())
	
	
func load_saved_hosts() -> void:
	# TODO: Load saved hosts from JSON
	var saved_data : Array = Global.readJSON(HOST_SAVE_FILE)
	for host_data: Dictionary in saved_data:
		var host_instance : BaseHost = BASE_HOST_SCENE.instantiate()
		hosts[host_data["name"]] = host_instance
	print("Loaded saved hosts: ", hosts.keys())
	
	
func get_host(host_name: String) -> BaseHost:
	if hosts.has(host_name):
		return hosts[host_name]
	else:
		print("Host not found: ", host_name)
		return null
		
		
func _init() -> void:
	# TODO: Condition for loading saved hosts
	load_default_hosts()
