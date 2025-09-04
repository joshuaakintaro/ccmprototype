extends Control

@onready var some_label : Node = $VBoxContainer/HBoxContainer/SomeButton

var match_settings : Dictionary = {
	"some_setting" : true,
}
signal exit_custom_menu

func _on_exit_button_pressed() -> void:
	hide()
	exit_custom_menu.emit()


func _on_some_button_pressed() -> void:
	#INFO: This is an example, and not a real function
	match_settings["some_setting"] = !match_settings["some_setting"]
