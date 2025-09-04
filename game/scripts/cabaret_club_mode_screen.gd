extends Control

@onready var classic_cabaret_mode_button : Node = $HBoxContainer/ClassicCabaretModeButton
@onready var bullet_mode_button : Node = $HBoxContainer/BulletCabaretModeButton
@onready var versus_mode_button : Node = $HBoxContainer/VersusModeButton
@onready var love_cabaret_button : Node = $HBoxContainer/VBoxContainer/LoveCabaretModeButton
@onready var gallery_mode_button : Node = $HBoxContainer/VBoxContainer/HBoxContainer/GalleryButton

signal cabaret_mode_selected

func _on_classic_cabaret_mode_button_pressed() -> void:
	cabaret_mode_selected.emit("classic")


func _on_bullet_cabaret_mode_pressed() -> void:
	cabaret_mode_selected.emit("bullet")


func _on_versus_mode_button_pressed() -> void:
	cabaret_mode_selected.emit("vs")


func _on_love_cabaret_button_pressed() -> void:
	cabaret_mode_selected.emit("love")


func _on_gallery_button_pressed() -> void:
	cabaret_mode_selected.emit("gallery")
