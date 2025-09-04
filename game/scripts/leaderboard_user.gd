extends HBoxContainer

@onready var user_character = $UserCharacter
@onready var user_name = $UserName
@onready var user_value = $UserValue

func set_character(characters : Array) -> void:
	var temp : String = ""
	for i : String in characters:
		temp += i[0]
	user_character.text = temp


func set_username(value : String) -> void:
	user_name.text = value


func set_value(value: float) -> void:
	# DANGER : SETS THE VALUE TO INT, FIND A WORKAROUND
	user_value.text = Utils.format_number_with_commas(value)
