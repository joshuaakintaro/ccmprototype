extends Node

func parse_json_as_dict(path: String) -> Dictionary:
	var result : Dictionary = _parse_json_raw(path)
	if typeof(result) != TYPE_DICTIONARY:
		push_error("Expected Dictionary but got %s in %s" % [typeof(result), path])
		assert(false)
	return result

func parse_json_as_array(path: String) -> Array:
	var result : Array= _parse_json_raw(path)
	if typeof(result) != TYPE_ARRAY:
		push_error("Expected Array but got %s in %s" % [typeof(result), path])
		assert(false)
	return result

func _parse_json_raw(path: String) -> Variant:
	var file : Variant = FileAccess.open(path, FileAccess.READ)
	assert(file != null, "Failed to open file: %s" % path)
	var content : Variant = file.get_as_text()
	var result : Variant = JSON.parse_string(content)
	assert(result != null, "JSON parse failed in %s. Content may be malformed." % path)
	return result
	
	
func get_screen_dimensions(width_percentage : float = 1.0, height_percentage : float = 1.0) -> Vector2:
	var dimension : Vector2 = get_viewport().get_visible_rect().size * Vector2(width_percentage, height_percentage)
	return dimension
	
	
func get_shape_point(shape_position: Vector2, shape_size: Vector2, point_input: String = "center") -> Vector2:
	match point_input:
		"top_left":
			return shape_position - shape_size
		"top_center":
			return Vector2(shape_position.x, shape_position.y - shape_size.y)
		"top_right":
			return Vector2(shape_position.x + shape_size.x, shape_position.y - shape_size.y)
		"center_left":
			return Vector2(shape_position.x - shape_size.x, shape_position.y)
		"center":
			return shape_position  # Default case: return center of shape
		"center_right":
			return Vector2(shape_position.x + shape_size.x, shape_position.y)
		"bottom_left":
			return Vector2(shape_position.x - shape_size.x, shape_position.y + shape_size.y)
		"bottom_center":
			return Vector2(shape_position.x, shape_position.y + shape_size.y)
		"bottom_right":
			return shape_position + shape_size
		_:
			push_warning("Invalid point_input '" + point_input + "', returning center")
			return shape_position
			
			
func print_scene_tree(node : Node = null, indent : int = 0): # For debugging dynamically created scenes
	if node == null:
		node = get_tree().get_root()  # Start from the root node
		
	print("  ".repeat(indent) + node.name + " (" + node.get_class() + ")")  # Indented tree structure
	
	for child in node.get_children():
		print_scene_tree(child, indent + 1)  # Recursively print child nodes


func format_number_with_commas(value: float) -> String:
	var value_str : String= str(value)
	var parts : PackedStringArray = value_str.split(".")
	var int_part : String = parts[0]
	var decimal_part : String
	if parts.size() > 1:
		decimal_part = "." + parts[1]
	else:
		decimal_part = ""
	
	var formatted : String = ""
	var count : int= 0

	for i in range(int_part.length() - 1, -1, -1):
		formatted = int_part[i] + formatted
		count += 1
		if count % 3 == 0 and i != 0:
			formatted = "," + formatted

	return formatted + decimal_part
