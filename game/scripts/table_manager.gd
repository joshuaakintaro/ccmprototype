extends Node2D

@export var table_scene: PackedScene
@onready var gameplay_host_manager = $GameplayHostManager

var current_id : int = 0
var tables: Dictionary = {}
var player_tables: Dictionary = {}
var enemy_tables : Dictionary = {}

func load_table_data(player_team : Array, enemy_team : Array) -> void:
	var gameplay_hosts : Dictionary = gameplay_host_manager.gameplay_hosts
	
	for i : Dictionary in player_team:
		var host_name = i["name"]
		var table_instance = table_scene.instantiate()
		add_child(table_instance)
		table_instance.initalise(current_id, gameplay_hosts[host_name])
		tables[current_id] = table_instance
		player_tables[host_name] = table_instance
		increment_table_id()
	
	for i : Dictionary in enemy_team:
		var host_name = i["name"]
		var table_instance = table_scene.instantiate()
		add_child(table_instance)
		table_instance.initalise(current_id,gameplay_hosts[host_name])
		tables[current_id] = table_instance
		enemy_tables[host_name] = table_instance
		increment_table_id()
	print("Loaded player tables: %s \nLoaded enemy tables: %s"% [player_tables.keys(), enemy_tables.keys()] )


func increment_table_id() -> void:
	current_id += 1
