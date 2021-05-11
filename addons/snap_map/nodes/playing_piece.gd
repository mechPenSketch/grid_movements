tool
extends Area2D

class_name PlayingPiece, "playing_piece.svg"

var grid_position = null

# CLASS DATA

func get_class():
	return "PlayingPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)
