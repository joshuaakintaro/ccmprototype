extends VBoxContainer

@export var checkpoint_button_scene : PackedScene

var chapter_scene : String

func load_checkpoints(data : Dictionary, scene : String) -> void:
	chapter_scene = scene
	for i : String in data:
		var checkpoint_button_instance = checkpoint_button_scene.instantiate()
		
		checkpoint_button_instance.text = data[i]["name"]
		checkpoint_button_instance.line = data[i]["line"]
		checkpoint_button_instance.call_checkpoint.connect(_on_call_checkpoint)
		add_child(checkpoint_button_instance)

func _on_call_checkpoint(line : int) -> void:
	Global.checkpoint_check = [true, line]
	get_tree().change_scene_to_file(chapter_scene)
