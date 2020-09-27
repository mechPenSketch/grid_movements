tool
extends RayCast2D

class_name RayCastPiece, "raycast_piece.svg"

# SNAP SETTINGS
enum AspectRatio {NONE, SQUARE, KEEP}
export(int) var cell_width = 64 setget set_cell_width
export(AspectRatio) var aspect_ratio = AspectRatio.SQUARE setget set_aspect_ratio
export(int) var cell_height = 64 setget set_cell_height

# INDIVIDUAL PARAMETERS
export(Vector2) var direction_ratio setget set_direction_ratio

# SETTING PARAM CHANGES
signal param_changed

# CLASS DATA

func get_class():
	return "RayCastPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)

# SETTING PROPERTIES THROUGH PLUGIN

func plugset_cell_width(w):
	cell_width = w
	var ratio = direction_ratio.x
	if ratio > 0:
		position.x = w / 2
		cast_to.x = w * (ratio - 0.5)
	elif ratio < 0:
		position.x = -w / 2
		cast_to.x = w * (ratio + 0.5)
	else:
		position.x = 0
		cast_to.x = 0

func plugset_aspect_ratio(e):
	aspect_ratio = e
	
func plugset_cell_height(h):
	cell_height = h
	var ratio = direction_ratio.y
	if ratio > 0:
		position.y = h / 2
		cast_to.y = h * (ratio - 0.5)
	elif ratio < 0:
		position.y = -h / 2
		cast_to.y = h * (ratio + 0.5)
	else:
		position.y = 0
		cast_to.y = 0

func get_snap_step()->Vector2:
	return Vector2(cell_width, cell_height)

# SETTING PROPERTIES THROUGH INSPECTOR

func set_direction_ratio(v2):
	var prev_dr = direction_ratio
	direction_ratio = v2
	
	if prev_dr.x != direction_ratio.x:
		plugset_cell_width(cell_width)
		
	if prev_dr.y != direction_ratio.y:
		plugset_cell_height(cell_height)
		
	property_list_changed_notify()

func set_cell_width(w):
	emit_signal("param_changed", "cell_width", w, self)

func set_aspect_ratio(e):
	emit_signal("param_changed", "aspect_ratio", e)

func set_cell_height(h):
	emit_signal("param_changed", "cell_height", h, self)
