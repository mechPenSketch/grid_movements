tool
extends Area2D

class_name PlayingPiece, "playing_piece.svg"

# SNAP SETTINGS
enum AspectRatio {NONE, SQUARE, KEEP}
export(int) var cell_width = 64 setget set_cell_width
export(AspectRatio) var aspect_ratio = AspectRatio.SQUARE setget set_aspect_ratio
export(int) var cell_height = 64 setget set_cell_height
export(int) var grid_x setget set_grid_x
export(int) var grid_y setget set_grid_y
var input_event

# SETTING PARAM CHANGES
signal param_changed

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if input_event is InputEventMouseButton:
			if !input_event.is_pressed():
				# SET GRID POSITION
				grid_x = int(position.x) / cell_width
				grid_y = int(position.y) / cell_width
				property_list_changed_notify()

func _plugin_input(e):
	input_event = e

# CLASS DATA

func get_class():
	return "PlayingPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)

# SETTING PROPERTIES THROUGH PLUGIN

func plugset_cell_width(w):
	cell_width = w
	set_pos_x()

func plugset_aspect_ratio(e):
	aspect_ratio = e
	
func plugset_cell_height(h):
	cell_height = h
	set_pos_y()

# SETTING PROPERTIES THROUGH INSPECTOR

func set_cell_width(w):
	emit_signal("param_changed", "cell_width", w, self)

func set_aspect_ratio(e):
	emit_signal("param_changed", "aspect_ratio", e)

func set_cell_height(h):
	emit_signal("param_changed", "cell_height", h, self)

func set_grid_x(gx):
	grid_x = gx
	set_pos_x()
	
func set_grid_y(gy):
	grid_y = gy
	set_pos_y()

func set_pos_x():
	position.x = (grid_x + 0.5) * cell_width
	
func set_pos_y():
	position.y = (grid_y + 0.5) * cell_height
