extends CanvasLayer

@onready var map_rect : Node = $MapRect
@onready var host_status_box : Node = $HostStatusBox
@onready var top_ui : Node = $TopUI

func set_healthbar_textures(value : Vector2i) -> void:
	get_tree().call_group("player_money_containers", "set_texture", value)
	
	

func get_special_button_containers() -> Array:
	return get_tree().get_nodes_in_group("special_button_containers")
	
	

func get_money_containers() -> Array:
	return get_tree().get_nodes_in_group("money_containers")
	
	
