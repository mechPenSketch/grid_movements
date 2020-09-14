tool
extends CollisionShape2D

class_name ColShapePiece, "colshape_piece.svg"

# SNAP SETTINGS
enum AspectRatio {NONE, SQUARE, KEEP}
export(int) var cell_width = 64 setget set_cell_width
export(AspectRatio) var aspect_ratio = AspectRatio.SQUARE setget set_aspect_ratio
export(int) var cell_height = 64 setget set_cell_height

# SETTING PARAM CHANGES
signal param_changed

# CLASS DATA

func get_class():
	return "ColShapePiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)

# SETTING PROPERTIES THROUGH PLUGIN

func plugset_cell_width(w):
	cell_width = w
	
	# AFFECTING SHAPE
	match shape.get_class():
		"RectangleShape2D":
			shape.extents.x = w/4
		"CircleShape2D":
			shape.radius = w/4
			cell_height = w

func plugset_aspect_ratio(e):
	aspect_ratio = e
	
func plugset_cell_height(h):
	cell_height = h
	
	# AFFECTING SHAPE
	match shape.get_class():
		"RectangleShape2D":
			shape.extents.y = h/4
		"CircleShape2D":
			shape.radius = h/4
			cell_width = h

# SETTING PROPERTIES THROUGH INSPECTOR

func set_cell_width(w):
	emit_signal("param_changed", "cell_width", w, self)

func set_aspect_ratio(e):
	emit_signal("param_changed", "aspect_ratio", e)

func set_cell_height(h):
	emit_signal("param_changed", "cell_height", h, self)
