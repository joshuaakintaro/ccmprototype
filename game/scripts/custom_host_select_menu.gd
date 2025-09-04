extends HostSelectMenu

@onready var custom_rules_button : Node = $CanvasLayer/CustomRulesButton
@onready var custom_select_menu : Node = $CanvasLayer/CustomSelectMenu

func _on_custom_rules_button_pressed() -> void:
	custom_rules_button.hide()
	custom_select_menu.show()


func _on_custom_select_menu_exit_custom_menu() -> void:
	custom_rules_button.show()


func _on_start_button_pressed() -> void:
	for i : String in area_available:
		if area_available[i]["bool"]:
			print("Needs a full team!")
			return

	set_host_team()
	"""
	ONLINE
	if Global.randomise_enemy:
		print("Randomising enemies...")
		set_random_enemy_team()
	"""
	print("Moving to scene path...")
	get_tree().change_scene_to_file(Global.host_select_path)
	# By default goes to level


func _on_reset_button_pressed() -> void:
	for i : Node in chosen_host_areas:
		i.reset()
		#print(i.get_children())
	for i : String in area_available:
		area_available[i]["bool"] = true
