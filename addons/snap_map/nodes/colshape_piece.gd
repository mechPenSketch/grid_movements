tool
extends CollisionShape2D

class_name ColShapePiece, "colshape_piece.svg"

# SETTING PARAM CHANGES
signal param_changed

# CLASS DATA

func get_class():
	return "ColShapePiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)
