extends CanvasLayer

@export var log_scene : PackedScene
@export var settings_scene : PackedScene
@export var vn_character : PackedScene

@onready var color_rect : Node = $ColorRect
@onready var background_texture : Node = $BackgroundTexture
@onready var vn_panel_texture : Node = $VisualNovelPanelTexture
@onready var vn_characters : Node = $VisualNovelCharacters
@onready var vn_textbox : Node = $MarginContainer/VisualNovelTextBox
@onready var settings_button : Node = $SettingsButton
@onready var log_button : Node = $LogButton

var character_sprites : Dictionary
var chapter_data : Array
var line_counter : int = 0

signal record_log
signal receive_panel_data

func _ready() -> void:
	vn_textbox.line_text.update_sprite.connect(_on_update_sprite)
	vn_textbox.line_text.start_speaking.connect(_on_start_speaking)
	vn_textbox.line_text.stop_speaking.connect(_on_stop_speaking)
	vn_textbox.line_text.flashing.connect(_on_flashing)
	## TESTING: printing save_data
	print("Save file: %s" % Global.get_save_file())
	load_chapter_data(Global.visual_novel_path)
	checkpoint_check()
	interpret_chapter_data()

func checkpoint_check() -> void:
	#INFO: Checks for access by checkpoints in Continue
	if Global.checkpoint_check[0]:
		line_counter = Global.checkpoint_check[1]
		print("Used Checkpoint at line: , ", line_counter)

func load_chapter_data(path : String) -> void:
	chapter_data = Utils.parse_json_as_array(path)


func interpret_chapter_data() -> void:
	if line_counter >= chapter_data.size():
		push_error("Chapter data has no exit.")
		assert(false)
	if chapter_data[line_counter].has("dialogue"):
		print("Generating Dialogue")
		generate_dialogue()
	if chapter_data[line_counter].has("commands"):
		print("Performing Command")
		perform_commands()


func generate_dialogue() -> void:
	vn_textbox.speaker = get_speaker_name()
	vn_textbox.line = get_line_data()
	vn_textbox.effects = get_effects()
	vn_textbox.output_dialogue()


func perform_commands() -> void:
	var commands : Dictionary = chapter_data[line_counter]["commands"]
	if commands.has("new_sprite"):
		for i : Dictionary in commands["new_sprite"]:
			print(i)
			new_sprite(i["character"], i["expression"])
			

	if commands.has("change_background"):
		change_background(commands["change_background"]["background"], commands["change_background"]["transition"])

	if commands.has("change_scene"):
		change_scene(commands["change_scene"])

	if commands.has("choice_dialogue"):
		choice_dialogue(commands["choice_dialogue"])
	if commands.has("screen_fade_out"):
		screen_fade_out()

	if commands.has("focus_dialogue"):
		focus_dialogue()

	if commands.has("undo_focus_dialogue"):
		unfocus_dialogue()

	if commands.has("spotlight_dialogue"):
		spotlight_dialogue()

	if commands.has("undo_spotlight_dialogue"):
		unspotlight_dialogue()

	if commands.has("monochrome"):
		monochrome()

	if commands.has("undo_monochrome"):
		undo_monochrome()
	increment_line_counter()
	interpret_chapter_data()

	if commands.has("save_file"):
		save_file(commands["save_file"])


func change_background(file_name : String, transition : String) -> void:
	background_texture.change_background(file_name, transition)


func new_sprite(character : String, expression : String) -> void:
	var vn_character_scene : Node = vn_character.instantiate()
	
	
	vn_character_scene.set_character(character)
	vn_character_scene.set_expression(expression)
	vn_character_scene.load_spriteframes()
	vn_character_scene.normal_animation()
	
	character_sprites[character] = vn_character_scene
	vn_characters.add_child(vn_character_scene)
	vn_character_scene.output_values()


# Transition to level
func change_scene(data : Dictionary) -> void:
	get_tree().change_scene_to_file(data["scene"])


func choice_dialogue(data : Dictionary) -> void:
	# Choices are typically 3, but can be anything, display as needed
	for i in data["choices"]:
		#Creates buttons for choices
		# display choice will assign chapter data to each choice to be used temporarily
		# will then return to typical chapter_data
		vn_textbox.display_choices(i)

func interpret_temp_data() -> void:
	# Temporarily runs through choice chapter data
	# At the end returns to normal data through bool assignment
	pass


func screen_fade_out() -> void:
	color_rect.z_index = 5
	color_rect.color = Color.BLACK
	color_rect.self_modulate.a = 0.0
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		color_rect.self_modulate.a += 0.2

	reset_color_rect()


func focus_dialogue() -> void:
	color_rect.z_index = 3
	color_rect.color = Color(Color.BLACK, 0.0)
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		color_rect.self_modulate.a += 0.1


func unfocus_dialogue() -> void:
	color_rect.z_index = 3
	color_rect.color = Color(Color.BLACK, 0.5)
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		color_rect.color.a -= 0.1
	reset_color_rect()


func spotlight_dialogue() -> void:
	color_rect.z_index = 3
	color_rect.color = Color(Color.BLACK, 0.0)
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		color_rect.color.a += 0.2

func unspotlight_dialogue() -> void:
	color_rect.z_index = 3
	color_rect.color = Color(Color.BLACK, 1.0)
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		color_rect.color.a -= 0.2
	reset_color_rect()


func monochrome() -> void:
	pass
	
	


func undo_monochrome() -> void:
	pass


func save_file(data : Dictionary) -> void:
	if data["key"] == "scenario":
		Global.save_scenario(data["payload"])
		print("Saved scenario data: %s" % data["payload"])

	if data["key"] == "story":
		Global.save_story(data["payload"]) #DANGER: DOES NOT EXIST
		print("Saved story data: %s" % data["payload"])

func reset_color_rect() -> void:
	color_rect.z_index = 0
	color_rect.color = Color(Color.BLACK, 0.0)

func increment_line_counter() -> void:
	line_counter += 1


func record_line_in_log() -> void:
	record_log.emit(chapter_data[line_counter])


func get_speaker_name() -> String:
	return chapter_data[line_counter]["dialogue"]["speaker"]


func get_line_data()-> String:
	return chapter_data[line_counter]["dialogue"]["line"]


func get_effects()-> Dictionary:
	if chapter_data[line_counter]["dialogue"].has("effects"):
		return chapter_data[line_counter]["dialogue"]["effects"]
	else:
		return {}


func _on_update_sprite(speaker : String, expression : String) -> void:
	if character_sprites.has(speaker):
		character_sprites[speaker].set_expression(expression)


func _on_start_speaking(speaker : String) -> void:
	if character_sprites.has(speaker):
		character_sprites[speaker].speaking_animation()


func _on_stop_speaking(speaker : String) -> void:
	if character_sprites.has(speaker):
		character_sprites[speaker].normal_animation()


func _on_flashing() -> void:
	print("FLASHING")
	color_rect.color = Color.WHITE
	color_rect.color.a = 0.2
	color_rect.z_index = 5
	for i in 4:
		await get_tree().create_timer(0.0625).timeout
		color_rect.color.a += 0.2

	reset_color_rect()


func _on_texture_button_pressed() -> void:
	var settings_menu : Node = settings_scene.instaniate()
	add_child(settings_menu)


func _on_log_button_pressed() -> void:
	var log_menu : Node = log_scene.instantiate()
	add_child(log_menu)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if vn_textbox.get_is_finished():
				record_line_in_log()
				increment_line_counter()
				interpret_chapter_data()
				print("Next line")
			else:
				vn_textbox.line_text.skip_text()
				print("Skipping through line")

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			if vn_textbox.get_is_finished():
				record_line_in_log()
				increment_line_counter()
				interpret_chapter_data()
				print("Next line")
			else:
				vn_textbox.skip_text()
				print("Skipping through line")
