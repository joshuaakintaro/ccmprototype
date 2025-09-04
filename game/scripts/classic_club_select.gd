extends Control

@export var classic_club_select_button_scene : PackedScene

@onready var select_buttons_container : Node = $HBoxContainer

var classic_club_selection_buttons : Array

signal club_selected

func load_classic_club_buttons(data: Dictionary) -> void:
	var instance : Node = classic_club_select_button_scene.instantiate()
	instance.load_data(data)
	instance.club_selected.connect(_on_club_selected)
	select_buttons_container.add_child(instance)
	classic_club_selection_buttons.append(instance)


func _on_club_selected(key: String) -> void:
	club_selected.emit(key)
