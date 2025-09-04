extends RichTextLabel

#region Script JSON format
"""
Example of what might be in the script JSON:
[
	{
		"dialogue" : {
			"speaker" : "Alice",
			"line": "Well, this is awkward...",
			"effects" : {
				"sprite_data" : [
					{
						"character" : "Alice",
						"expression" : "white",
						"position" : 50,
					},
					{
						"name" : "Alice",
						"expression" : "red",
						"position" : 30,
					}
				],
				"sound" : "beep_fast",
				"pause_at" : [5],
			}
		},
		"commands" : {
			"create_sprite" : [
				{
					"entry" : "fade-in",
					"character" : "Alice",
					"expression" : "default",
			},
		],
		}
	},
	{
		"dialogue" : {
			"speaker" : "Alice",
			"line" : "I didn't think you'd actually show up. Care to explain?",
			"effects" : {
				"sprite" : [
					{
						"expression" : "nervous",
						"character": 50,
					}
				],
				"sound" : "beep_normal",
				"emotion" : "excited",
				"pause_at" : [12, 25],
				"flash_at" : [0],
				"highlight" : [{"start" : 22, "end" : 30}]
			},
		},
	},
	{
		"commands" : {
			"transition_map" : {
				"map" : "Testmap",
				"transition" : "fade-in",
			},
		},
	}
]
	
"""
#endregion
@onready var normal_dialogue_timer : Node = $NormalDialogueTimer
@onready var slow_dialogue_timer : Node = $SlowDialogueTimer
@onready var pause_dialogue_timer : Node = $PauseDialogueTimer

var speaker : String
var line : String
var effects : Dictionary

var sprite_data : Array
var pause : Array
var flash : Array
var invert : Array
var slowdown : Array
var highlight : Array

var is_finished : bool = true
var skip : bool = false

signal start_speaking
signal stop_speaking
signal update_sprite
signal flashing

func output_line() -> void:
	text = ""
	is_finished = false
	skip = false # Allows for skipping dialogue transcription for full line
	get_line_effects()
	var character : int = 0
	var line_length = line.length()
	print(line)
	while character < line_length:
		## INFO:  Backtick ("`") is used to signify BBCode
		if line[character] == "`":
			while true: #Skips until next backtick
				character += 1
				if line[character] == "`":
					break
				
				
		text += line[character]
		#region for loop
		for index in sprite_data:
			if character == index["position"]:
				update_sprite.emit(index["character"], index["expression"])
				
		# VisualNovelCharacter gets signal for speaking animation
		start_speaking.emit(speaker)
		
		for index in pause:
			if character == index:
				stop_speaking.emit(speaker)
				pause_dialogue_timer.start()
				skip = false
				# Stops at pause, continues normally
				await pause_dialogue_timer.timeout
				print("timed out")
				
		for index in flash:
			if character == index:
				flashing.emit()
				
		for index in slowdown:
			if character == index:
				if skip == false:
					slow_dialogue_timer.start()
					await slow_dialogue_timer.timeout
				
		for index in highlight:
			if character == index:
				pass
				
		#endregion
		if skip == false:
			normal_dialogue_timer.start()
			await normal_dialogue_timer.timeout
		character += 1 #NOTE: Backtick condition will go to next character after found
	is_finished = true
	stop_speaking.emit(speaker)

func skip_text() -> void:
	skip = true
	# Skips pause 
	pause_dialogue_timer.stop()
	pause_dialogue_timer.timeout.emit()


func get_line_effects() -> void:
	print(effects)
	if effects.has("sprite_data"):
		for i in effects["sprite_data"]:
			sprite_data.append(effects[sprite_data][i])
	if effects.has("pause_at"):
			pause = effects["pause_at"]
			print(pause)
	if effects.has("flash_at"):
			flash = effects["flash_at"]
	if effects.has("invert_at"):
			invert = effects["invert"]
	if effects.has("slowdown_at"):
		slowdown = effects["slowdown_at"]
	if effects.has("highlight_at"):
		highlight = effects["highlight_at"]
			
			
