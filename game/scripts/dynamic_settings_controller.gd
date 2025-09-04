extends Control

class_name DynamicSettingsController

@onready var settings_container : DynamicSettingsContainer = $DynamicSettingsContainer

var settings : Dictionary
# { "settings_name" : default, ...}

var data : Array
#[ { "label" : ""
# "button_data" : { "text" : "", "variables" : {}, "parameter" : Variant } }]
#
func get_settings() -> Dictionary:
	return settings


func load_settings() -> void:
	settings_container.update_settings.connect(_on_update_settings)
	# NOTICE: Data should include label and button dictionaries
	for i : Dictionary in data:
		settings_container.new_setting(i)


func _on_update_settings(key : String, value : Variant) -> void:
	var temp : String = str(settings[key])
	settings[key] = value
	print("Setting: %s updated from %s to %s!" % [key, temp, value])
	
