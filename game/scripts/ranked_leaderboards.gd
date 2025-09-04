extends TabContainer

@onready var elo_leaderboard = $ELO
@onready var elo_leaderboard_table = $ELO/LeaderboardTable
@onready var most_matches_leaderboard = $MostMatches
@onready var most_matches_leaderboard_table = $MostMatches/LeaderboardTable

var elo_data : Array
var matches_data : Array
var data_multiples : Dictionary = {
	"elo" : 0,
	"matches" : 0
}

func set_user_data(data : Array) -> void:
	var temp : Dictionary
	for i in data:
		elo_data.append({
			"character" : i["favorite_characters"],
			"username" : i["name"],
			"value" : i["elo"]
			})
		matches_data.append({
			"character" : i["favorite_characters"],
			"username" : i["name"],
			"value" : i["matches"]
			})

	elo_data.sort_custom(func(a, b): return a["value"] < b["value"])
	matches_data.sort_custom(func(a, b): return a["value"] < b["value"])
	elo_leaderboard_table.set_users(set_to_ten(elo_data, "elo"))
	most_matches_leaderboard_table.set_users(set_to_ten(matches_data, "matches"))


func set_to_ten(data : Array, leaderboard : String) -> Array:
	var temp : Array
	for i in range(data_multiples[leaderboard], data_multiples[leaderboard] + 10):
		temp.append(data[i])
	return temp
