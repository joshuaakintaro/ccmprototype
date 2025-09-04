extends RichTextLabel

var current_amount : int

func _process(delta: float) -> void:
	text = "Player 1: $ " + Utils.format_number_with_commas(current_amount) #Needs to roll the money up
	
	
func add_money(amount : int) -> void:
	current_amount += amount
	
func get_money() -> int:
	return current_amount
	
