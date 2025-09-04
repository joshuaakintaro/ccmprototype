extends AnimatedSprite2D

class_name CustomisationHost

# Properties have to be made in a way that can be iterated without knowing an amount inside
static var host_name : String
var head : Dictionary
var top : Dictionary
var bottom : Dictionary
var accessories : Dictionary

func initialisation(data: Dictionary) -> void:
	#INFO: Hosts will have default clothings if the player does not have a saved customisation
	host_name = data.get("name")
	head = data.get("head")
	top = data.get("top")
	bottom = data.get("bottom")
	accessories = data.get("accessories")
	
	
func add_head(location: String, head_data : Dictionary) -> void:
	# TODO: add validation for face accessories
	# INFO: Technically, there is a layer with the hair, but it isn't significant enough
	head[location] = head_data
	
	
func add_clothing(layer : int, clothing: Dictionary) -> void:
	# INFO: clothing_data contains one layer, one or many colors, color location and clothing id
	if clothing["location"] == "top":
		if clothing in top:
			print("Already assigned clothing")
		else:
			top[clothing[layer]] = clothing["clothing_data"]
	elif clothing["location"] == "bottom":
		if clothing in bottom:
			print("Already assigned clothing")
		else:
			bottom[clothing[layer]] = clothing["clothing_data"]
	elif clothing["location"] == "accessories":
		if clothing in accessories:
			print("Already assigned clothing")
		else:
			top[clothing[layer]] = clothing["clothing_data"]
		
		
func remove_clothing(location: String, selected_layer : int) -> void:
	# WARNING: Assign to null might have strange effects, should use default clothes
	if location == "top":
		top[selected_layer] = null
	elif location == "bottom":
		bottom[selected_layer] = null
	else:
		assert("Clothing location not found: ", location)
	
	
func add_accessories(location : String, accessories_data : Dictionary) -> void:
	# TODO: add validation for accessories
	accessories[location] = accessories_data
	
	
func remove_accessories(location: String) -> void:
	accessories[location] = null
	
	
