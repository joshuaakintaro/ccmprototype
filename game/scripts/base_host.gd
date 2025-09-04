extends Node2D

class_name BaseHost

#Host properties
var host_name: String
var level: int
var appearance : Dictionary
var status : Dictionary
var performance : Dictionary
var special : Dictionary


func initalise(data: Dictionary) -> void:
	host_name = data.get("name")
	level = data.get("level")
	appearance = data.get("appearance")
	status = data.get("status")
	performance = data.get("performance")
	special = data.get("special")
	
	
func get_appearance() -> Dictionary:
	return appearance
	
	
func get_status() -> Dictionary:
	return status
	
	
func get_performance() -> Dictionary:
	return performance
	
	
func get_special() -> Dictionary:
	return special
	
	
