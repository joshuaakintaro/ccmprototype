extends HostSelectMenu

signal move_page

func _on_start_button_pressed() -> void:
	for i : String in area_available:
		if area_available[i]["bool"]:
			print("Needs a full team!")
			return
	set_host_team()
	move_page.emit()


func _on_reset_button_pressed() -> void:
	for i : Node in chosen_host_areas:
		i.reset()
		#print(i.get_children())
	for i : String in area_available:
		area_available[i]["bool"] = true
