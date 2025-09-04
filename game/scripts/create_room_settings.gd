extends DynamicSettingsController


func _ready() -> void:
	# Definitions
	settings = {
		"some_setting" : 50,
		"some_something" : 20
	}
	data = [
		{
			"label" : "Some Setting",
			"button_data" : {
				"text" : "Some Button",
				"variables" : {"value" : true, "tst" : "red"},
				"parameter" : "value"
			}
		},
	]

	# Initalisation
	load_settings()

# { "label" : ""
# "button_data" : { "text" : "", "variables" : {}, "parameter" : Variant } }
#
