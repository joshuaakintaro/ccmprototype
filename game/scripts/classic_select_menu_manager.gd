extends Control

@onready var classic_club_select_menu : Node = $ClassicClubSelectMenu
@onready var classic_scenario_menu : Node = $ClassicScenarioMenu
@onready var back_button : Node = $BackButton

func _ready() -> void:
	classic_club_select_menu.show_menu.connect(_on_show_menu)
	back_button.pressed.connect(_on_back_button_pressed)


func _on_show_menu(key: String) -> void:
	print("Showing ", key, " menu.")
	
	classic_club_select_menu.hide()
	classic_scenario_menu.show()
	
	classic_scenario_menu.load_club_scenario_data(key)
	classic_scenario_menu.load_save_file()
	classic_scenario_menu.load_background()
	classic_scenario_menu.load_classic_scenario_buttons()


func _on_back_button_pressed() -> void:
	classic_scenario_menu.reset_buttons()
	classic_scenario_menu.hide()
	classic_club_select_menu.show()
