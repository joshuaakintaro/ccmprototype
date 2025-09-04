extends VBoxContainer

class_name SpecialButtonContainer

@onready var skill_button : Node = $SkillButton
@onready var ability_button : Node = $AbilityButton

signal special_activation

func _ready() -> void:
	add_to_group("special_button_containers")
	
func load_special_buttons(special_data : Dictionary) -> void:
	skill_button.initalise(special_data["skill"], special_data["table"])
	skill_button.using_special.connect(_on_special_activation)
	ability_button.initalise(special_data["ability"], special_data["table"])
	ability_button.using_special.connect(_on_special_activation)
	
	
func _on_special_activation(special_name : String, target: String, effect_data : Dictionary, value : float, time : float, max_value : bool, table : Object) -> void:
	special_activation.emit(special_name, target, effect_data, value, time, max_value, table)
	
	
