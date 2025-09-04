extends VBoxContainer

@onready var texture_rect : Node = $PanelContainer/TextureRect
@onready var player_money_label : Node = $PanelContainer/PlayerMoneyLabel
var healthbar_image : Image = load("res://game/assets/textures/map_textures/healthbar_texture/test_healthbar_texture.png")

func _ready() -> void:
	add_to_group("money_containers")
	
	
func set_texture(image_dimensions: Vector2i) -> void:
	healthbar_image.resize(image_dimensions.x, image_dimensions.y)
	var texture : ImageTexture = ImageTexture.create_from_image(healthbar_image)
	texture_rect.texture = texture
	
	

func get_money() -> int:
	return player_money_label.current_amount
	
