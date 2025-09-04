extends Node2D

@export var vn_character_scene : PackedScene
@onready var vn_ui_manager : Node = $VisualNovelUIManager

var vn_characters : Dictionary

func _on_new_character(character : String) -> void:
	if not vn_characters.has(character):
		var character_sprite_2d = vn_character_scene.instantiate()
		character_sprite_2d.set_character(character)
		vn_characters[character] = character_sprite_2d
		add_child(character_sprite_2d)
	
	
func _on_update_sprite(character : String, expression_name : String) -> void:
	vn_characters[character].update_sprite(expression_name)
	
	

func _on_character_speaking(character : String) -> void:
	vn_characters[character].speaking_animation()
	
	
func _on_stop_speaking(character : String)-> void:
	vn_characters[character].normal_animation()
func connect_signals() -> void:
	vn_ui_manager.vn_textbox.new_character.connect(_on_new_character)
	vn_ui_manager.vn_textbox.dialogue_box.update_sprite.connect(_on_update_sprite)
	vn_ui_manager.vn_textbox.dialogue_box.character_speaking.connect(_on_character_speaking)
	vn_ui_manager.vn_textbox.dialogue_box.stop_speaking.connect(_on_stop_speaking)
	
	

"""
This is a template each chapter and sub-chapter can build upon.
Scripts decide the pace of the story.
That includes dialogue, sprites and on-screen effects.
It also includes map changes and choices to be made

But script is already specialised for dialogue and characters and panels
Map transitions would be annoying but possible
"""
