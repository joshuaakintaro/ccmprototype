extends Control

@onready var text_edit : Node = $VBoxContainer/TextEdit
@onready var submit_button : Node = $VBoxContainer/HBoxContainer/SubmitButton
@onready var cancel_button : Node = $VBoxContainer/HBoxContainer/CancelButton

func _on_submit_button_pressed() -> void:
	print("Entered room code %s" % text_edit.text)
	
	## SUGGESTION: Add some validation for a real code
	## Pathway to room with checks for if it works
	## Timeout and alert player if unfound
	## If found send host to room in room browser


func _on_cancel_button_pressed() -> void:
	hide() # Might be redundant with exit button


func _on_exit_button_pressed() -> void:
	hide()
