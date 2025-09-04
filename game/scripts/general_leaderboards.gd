extends TabContainer

@onready var net_worth_leaderboard = $NetWorth
@onready var net_worth_leaderboard_table = $NetWorth/LeaderboardTable
@onready var progression_leaderboard = $Progression
@onready var progression_leaderboard_table = $Progression/LeaderboardTable

var net_worth_data : Array
var progression_data : Array
var data_multiples : Dictionary = {
	"networth" : 0,
	"progression" : 0
}

func set_user_data(data : Array) -> void:
	var temp : Dictionary
	for i in data:
		net_worth_data.append({
			"character" : i["favorite_characters"],
			"username" : i["name"],
			"value" : i["networth"]
			})
		progression_data.append({
			"character" : i["favorite_characters"],
			"username" : i["name"],
			"value" : i["progression"]
			})

	net_worth_data.sort_custom(func(a, b): return a["value"] < b["value"])
	progression_data.sort_custom(func(a, b): return a["value"] < b["value"])
	net_worth_leaderboard_table.set_users(set_to_ten(net_worth_data, "networth"))
	progression_leaderboard_table.set_users(set_to_ten(progression_data, "progression"))


func set_to_ten(data : Array, leaderboard : String) -> Array:
	var temp : Array
	for i in range(data_multiples[leaderboard], data_multiples[leaderboard] + 10):
		temp.append(data[i])
	return temp
