extends VBoxContainer

@onready var name_text : Node = $NameText
@onready var line_text : Node = $LineText

var speaker : String
var line : String
var effects : Dictionary

func output_dialogue() -> void:
	name_text.text = speaker
	line_text.speaker = speaker
	line_text.line = line
	line_text.effects = effects
	line_text.output_line()


func get_is_finished() -> bool:
	return line_text.is_finished


func set_is_finished(value : bool) -> void:
	line_text.is_finished = value
