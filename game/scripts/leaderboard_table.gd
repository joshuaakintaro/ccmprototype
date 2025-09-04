extends VBoxContainer

@onready var children : Array[Node] = get_children()

func set_users(users : Array) -> void:
	for i in users.size():
		children[i].set_character(users[i]["character"])
		children[i].set_username(users[i]["username"])
		children[i].set_value(users[i]["value"])
