extends GridContainer

@export var item_scene : PackedScene


func initalise(data: Dictionary) -> void:
	# Loads packedscene of desired items to show
	# Loads buttons for as many exists inside the grid
	# The data gathered tells which data file to use for customisation
	for item_index in data:
		var item = item_scene.instantiate()
		item.initalise(item_index)
		add_child(item)
		# Need to place these buttons inside the container
	
	
