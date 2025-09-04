extends TabContainer

@export var item_scene : PackedScene


func initalise(data: Dictionary) -> void:
	# Loads packedscene of desired items to show
	# Loads buttons for as many exists inside the grid
	# The data gathered tells which data file to use for customisation
	for tab_index in data:
		var tab = item_scene.instantiate()
		tab.initalise(tab_index)
		add_child(tab)
		# Need to place these buttons inside the container
	
