extends Node2D

@export var special_button_instance: PackedScene
@onready var button_array = $Control.get_children()
var special_buttons: Dictionary

var host_special : Dictionary
var array_counter : int = 0

func load_host_special(skill_id: String, ability_id: String, trait_id: String, host_name : String) -> Dictionary:
	host_special = {}
	host_special["skill"] = load_skill_data(skill_id, Global.SKILL_DATA)
	host_special["ability"] = load_ability_data(ability_id, Global.ABILITY_DATA)
	host_special["trait"] = load_trait_data(trait_id, Global.TRAIT_DATA)
	
	assign_special_button(host_special["skill"], host_special["ability"], host_name)
	return host_special # Saved for every host for in game use
	
	
func load_skill_data(skill_id: String, data_source: Array) -> Dictionary:
	if skill_id in data_source[0]["skill"]:
		var skill : Dictionary = data_source[0]["skill"][skill_id]
		return skill
	else:
		assert("Can't find data for specified skill id: ", skill_id)
		return {}
		
		
func load_ability_data(ability_id: String, data_source: Array) -> Dictionary:
	if ability_id in data_source[0]["ability"]:
		return data_source[0]["ability"][ability_id]
	else:
		assert(false, "Can't find data for specified ability_id")
		return {}
		
		
func load_trait_data(trait_id: String, data_source: Array) -> Dictionary:
	if trait_id in data_source[0]["trait"]:
		return data_source[0]["trait"][trait_id]
	else:
		assert(false, "Can't find trait data for specificed trait id: ")
		return {}
		
		
func assign_special_button(skill: Dictionary, ability : Dictionary, host_name : String) -> void:
	var button_dictionary = {"skill" : button_array[array_counter], "ability" : button_array[array_counter + 1]}
	button_dictionary["skill"].initalise(skill)
	button_dictionary["ability"].initalise(ability)
	special_buttons[host_name] = button_dictionary
	increment_array_counter()
	
	
func increment_array_counter() -> void:
	array_counter += 2
	
	
