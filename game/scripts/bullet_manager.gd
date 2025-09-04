extends Node2D

@onready var bullet_host_select_menu : Node = $BulletHostSelectMenu

## WARNING: CHANGE TO BULLET GAMEPLAY
var bullet_gameplay_directory : String = "res://game/scenes/level.tscn"
func _ready() -> void:
	Global.host_select_path
	bullet_host_select_menu.move_page.connect(_on_move_page)


func _on_move_page() -> void:
	bullet_host_select_menu.hide()
	bullet_host_select_menu.canvas_layer.hide()
