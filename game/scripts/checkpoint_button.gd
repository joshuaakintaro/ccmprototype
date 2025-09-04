extends Button

var line : int

signal call_checkpoint

func _on_pressed() -> void:
	call_checkpoint.emit(line)
