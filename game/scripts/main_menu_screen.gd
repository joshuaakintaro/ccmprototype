extends Control

@onready var story_mode_button : Node = $HBoxContainer/VBoxContainer/StoryModeButton
@onready var cabaret_club_mode_button : Node = $HBoxContainer/VBoxContainer/CabaretClubModeButton
@onready var online_mode_button : Node = $HBoxContainer/VBoxContainer2/OnlineModeButton
@onready var shop_button : Node = $HBoxContainer/VBoxContainer2/HBoxContainer/ShopButton
@onready var customisation_mode_button : Node = $HBoxContainer/VBoxContainer2/HBoxContainer/CustomisationModeButton

signal main_mode_selected

func _on_story_mode_button_pressed() -> void:
	main_mode_selected.emit("story")


func _on_cabaret_club_mode_button_pressed() -> void:
	main_mode_selected.emit("cabaret")


func _on_online_mode_button_pressed() -> void:
	main_mode_selected.emit("online")


func _on_shop_button_pressed() -> void:
	main_mode_selected.emit("shop")


func _on_customisation_mode_button_pressed() -> void:
	main_mode_selected.emit("customisation")
