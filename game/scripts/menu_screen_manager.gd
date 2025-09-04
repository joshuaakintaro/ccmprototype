extends Node

@onready var main_menu : Node = $MainMenu
@onready var map_screen_menu : Node = $MapScreenManager
@onready var cabaret_club_mode_menu : Node = $CabaretClubModeMenu
@onready var online_mode_menu : Node = $OnlineModeMenu
@onready var leaderboards_menu : Node = $LeaderboardsMenu
@onready var player_match_menu : Node = $PlayerMatchMenu

## INFO: PATHWAY CHECK LIST
## Classic: COMPLETE
## Team Selection : COMPLETE

var shop_manager_path : String = "res://game/scene_managers/shop_manager.tscn"
var customisation_manager_path : String = "res://game/scene_managers/customisation_manager.tscn"
var classic_manager : String = "res://game/scene_managers/classic_select_menu_manager.tscn"
var bullet_manager : String = "res://game/scene_managers/bullet_manager.tscn"
var versus_host_select_menu : String = "res://game/scenes/versus_host_select_menu.tscn"
var love_manager : String = "res://game/scene_managers/love_manager.tscn"
var gallery_manager : String = "res://game/scene_managers/gallery_manager.tscn"
var host_select_menu : String = "res://game/scenes/host_select_menu.tscn"

func _ready() -> void:
	main_menu.main_mode_selected.connect(_on_main_mode_selected)
	cabaret_club_mode_menu.cabaret_mode_selected.connect(_on_cabaret_mode_selected)
	online_mode_menu.online_mode_selected.connect(_on_online_mode_selected)
	# shop_menu_screen.shop_mode_selected.connect(_on_shop_mode_selected)
	## INFO: Might need to load on its own for data


func _on_main_mode_selected(mode : String) -> void:
	main_menu.hide()
	match mode:
		"story":
			map_screen_menu.show()
		"online":
			# NOTICE: Might want to do a network check if not finishd
			online_mode_menu.show()
		"cabaret":
			cabaret_club_mode_menu.show()
		"shop":
			get_tree().change_scene_to_file(shop_manager_path)
		"customisation":
			get_tree().change_scene_to_file(customisation_manager_path)


func _on_cabaret_mode_selected(mode : String) -> void:
	match mode:
		"classic":
			get_tree().change_scene_to_file(classic_manager)
		"bullet":
			Global.host_select_path = "" #NEEDS TO GO TO ATW
			get_tree().change_scene_to_file(bullet_manager)
		"vs":
			pass
			get_tree().change_scene_to_file(versus_host_select_menu)
		"love":
			get_tree().change_scene_to_file(love_manager)
		"gallery":
			get_tree().change_scene_to_file(gallery_manager)


func _on_online_mode_selected(mode : String) -> void:
	match mode:
		"event":
			Global.host_select_path = "" ##TESTING: Goes to event level
			Global.online_match = "event"
			get_tree().change_scene_to_file(host_select_menu)
		"quick":
			Global.host_select_path = "res://game/scene_managers/level_manager.tscn" ##TESTING: Goes to normal level
			Global.online_match = "quick"
			get_tree().change_scene_to_file(host_select_menu)
		"ranked":
			Global.host_select_path = "res://game/scene_managers/level_manager.tscn" ##TESTING: Goes to normal level
			Global.online_match = "ranked"
			get_tree().change_scene_to_file(host_select_menu)
		"player":
			online_mode_menu.hide()
			player_match_menu.show()
		"leaderboards":
			leaderboards_menu.show()
			## NOTICE: Shows on top
