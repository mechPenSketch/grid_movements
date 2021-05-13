tool
extends RayCast2D

class_name RayCastPiece, "raycast_piece.svg"

# INDIVIDUAL PARAMETERS
export(Vector2) var direction_ratio setget set_direction_ratio, get_direction_ratio

# CLASS DATA

func get_class():
	return "RayCastPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)
	
# PROPERTIES DATA

func get_direction_ratio():
	return direction_ratio

func set_direction_ratio(val):
	# SET PROPERTY
	direction_ratio = val
	
	if Engine.editor_hint:
		# GET PARENT
		var parent = get_parent()
		# IF THESE CONDITIONS ARE MET
		#	- PARENT IS NOT NULL
		#	- PARENT IS PLAYING PIECE
		#	- THERE IS GRANDPARENT TILEMAP
		if parent and parent.is_class("PlayingPiece") and parent.parent_tilemap:
			set_direction(parent.parent_tilemap.get_cell_size())
		else:
			position = Vector2()
			cast_to = direction_ratio * 64

# SETTING PROPERTIES THROUGH INSPECTOR

func set_direction(snap_grid_step):
	# STARTING POS
	var base = Vector2()
	for w in 2:
		if direction_ratio[w] < 0:
			base[w] = -1
		elif direction_ratio[w] > 0:
			base[w] = 1
	position = base * snap_grid_step / 2
	
	# FINAL POS
	var final_multiplier = get_direction_ratio() - base * Vector2(0.5, 0.5)
	cast_to = snap_grid_step * final_multiplier
	
	property_list_changed_notify()
