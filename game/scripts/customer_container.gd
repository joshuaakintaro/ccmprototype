extends Container

@export var position_height_percentage : float
@export var position_width_percentage : float

@export var x_size_height_percentage : float
@export var x_size_width_percentage : float
@export var y_size_height_percentage : float
@export var y_size_width_percentage : float


func _ready() -> void:
	#set_container_position()
	#set_container_size()
	print(position)
	print(size)
	
func set_container_position() -> void:
	var desired_position = Global.find_screen_position(position_width_percentage, position_height_percentage)
	position = Vector2(desired_position[0], desired_position[1])
	
	
func set_container_size() -> void:
	var line_1 = Global.find_screen_position(x_size_height_percentage,x_size_width_percentage)
	var line_2 = Global.find_screen_position(y_size_height_percentage,y_size_width_percentage)
	
	var width = abs(line_2[0] - line_1[0])
	var height = abs(line_2[1] - line_1[0])
	size = Vector2(width,height)
