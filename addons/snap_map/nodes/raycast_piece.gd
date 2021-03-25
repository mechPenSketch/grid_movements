tool
extends RayCast2D

class_name RayCastPiece, "raycast_piece.svg"

# INDIVIDUAL PARAMETERS
export(Vector2) var direction_ratio setget set_direction_ratio

# SETTING PARAM CHANGES
signal param_changed

# CLASS DATA

func get_class():
	return "RayCastPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)

# SETTING PROPERTIES THROUGH INSPECTOR

func set_direction_ratio(v2):
	"""
	var prev_dr = direction_ratio
	direction_ratio = v2
	
	if prev_dr.x != direction_ratio.x:
		plugset_cell_width(cell_width)
		
	if prev_dr.y != direction_ratio.y:
		plugset_cell_height(cell_height)
		
	property_list_changed_notify()
	"""
	pass
