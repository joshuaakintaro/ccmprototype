extends Control

@onready var event_mode_button : Node = $VBoxContainer/EventModeButton
@onready var quick_match_button : Node = $VBoxContainer/HBoxContainer/QuickMatchButton
@onready var ranked_match_button : Node = $VBoxContainer/HBoxContainer/RankedMatchButton
@onready var player_match_button : Node = $VBoxContainer/HBoxContainer/VBoxContainer/PlayerMatchButton
@onready var leaderboards_button : Node = $VBoxContainer/HBoxContainer/VBoxContainer/LeaderboardsButton

signal online_mode_selected

func _on_event_mode_button_pressed() -> void:
	online_mode_selected.emit("event")


func _on_quick_match_button_pressed() -> void:
	online_mode_selected.emit("quick")


func _on_ranked_match_button_pressed() -> void:
	online_mode_selected.emit("ranked")


func _on_player_match_button_pressed() -> void:
	online_mode_selected.emit("player")


func _on_leaderboards_button_pressed() -> void:
	online_mode_selected.emit("leaderboards")
