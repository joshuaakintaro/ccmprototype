extends RichTextLabel

var current_time : int = 30
signal round_ended
func _process(delta: float) -> void:
	text = "Time left: " + str(current_time) #Needs to roll the money up
	
	
func set_time(time : int) -> void:
	current_time = time
	
	
func update_time() -> void:
	current_time -= 1
	if current_time == 0:
		round_ended.emit()
	
	
func get_time_left() -> int:
	return current_time
	
	
