tool
extends Area2D

class_name PlayingPiece, "playing_piece.svg"

var input_event

# SETTING PARAM CHANGES
signal param_changed

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if input_event is InputEventMouseButton:
			if !input_event.is_pressed():
				pass

func _plugin_input(e):
	input_event = e

# CLASS DATA

func get_class():
	return "PlayingPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)
