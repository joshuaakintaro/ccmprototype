extends Control

"""
Leaderboards will load all ranked information taking from a network
This will be filtered by settings like:
	unfiltered
	most used characters (3 available), can choose if all inclusive
Sub-tabs might have more things to search with:
	General:
		Networth (Made of money, and clothing)
		Progrsesion (Made up of hours played and things unlocked)
	Ranked:
		ELO, Most Matches, Most Match Wins
	Classic:
		Most Money Made, Total Earnings
	
	
"""

@onready var general_leaderboards : Node = $Leaderboards/GeneralLeaderboards
@onready var ranked_leaderboards : Node = $Leaderboards/RankedLeaderboards
@onready var classic_leaderboards : Node = $Leaderboards/ClassicLeaderboard

var user_data : Array
var display_increment : int
var current_leaderboard : Dictionary = {
	"big_table" : 0,
	"sub_table" : 0,
}
var general_leaderboard_index : Dictionary = {
	"net_worth" : 0,
	"manager_rating" : 1,
}

var ranked_leaderboard_index : Dictionary = {
	"elo" : 0,
	"most_matches" : 1,
}

var classic_leaderboard_index : Dictionary = {
	"highest_earner" : 0,
	"total_earnings" : 1,
}


func _ready() -> void:
	load_network_data()
	load_leaderboards()


func load_network_data() -> void:
	## INFO: asks from the network for data from every user:
	# Data is avatar, name, ID, and various points of data
	## INFO: Temporarily calling from a placeholder JSON
	user_data = Utils.parse_json_as_array("res://game/data/user_data/user_data.json")

func load_leaderboards() -> void:
	ranked_leaderboards.set_user_data(user_data)
	general_leaderboards.set_user_data(user_data)


func _on_exit_button_pressed() -> void:
	hide()


func _on_back_button_pressed() -> void:
	pass # Replace with function body.


func _on_forward_button_pressed() -> void:
	pass # Replace with function body.
