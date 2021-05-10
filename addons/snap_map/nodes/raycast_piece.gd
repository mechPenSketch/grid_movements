tool
extends RayCast2D

class_name RayCastPiece, "raycast_piece.svg"

# INDIVIDUAL PARAMETERS
export(Vector2) var direction_ratio setget ,get_direction_ratio

# SETTING PARAM CHANGES
signal param_changed

# CLASS DATA

func get_class():
	return "RayCastPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)
	
# PROPERTIES DATA

func get_direction_ratio():
	return direction_ratio

# SETTING PROPERTIES THROUGH INSPECTOR

func plugset_direction(snap_grid_step):
	var half_step = snap_grid_step / 2
	var net_direction = half_step * get_direction_ratio()
	set_position(net_direction)
	set_cast_to(net_direction)
	property_list_changed_notify()
