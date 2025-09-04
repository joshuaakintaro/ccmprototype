extends Node2D

var value : float
var max_value : bool
var duration : float

func initalise(data: Dictionary) -> void:
	value = data.get("value")
	max_value = data.get("max_value")
	duration = data.get("duration")
	
	
func apply_effect() -> void:
	pass
	
	
func create_effect_timer() -> void:
	$EffectTimer.start(duration)
	
	
func _on_effect_timer_timeout() -> void:
	# Revese effect
	# Remove reference
	pass
	
	
