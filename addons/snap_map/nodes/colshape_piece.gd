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

# SHAPE DATA

func get_half_width():
	match shape.get_class():
		"RectangleShape2D":
			return shape.extents.x
		"CircleShape2D", "CapsuleShape2D":
			return shape.radius
		_:
			return shape.width

func get_half_height():
	match shape.get_class():
		"RectangleShape2D":
			return shape.extents.y
		"CircleShape2D":
			return shape.radius
		_:
			return shape.height

# SETTING PROPERTIES THROUGH PLUGIN

func plugset_cell_width(w):
	cell_width = w
	set_shape_width()

func plugset_aspect_ratio(e):
	aspect_ratio = e
	
func plugset_cell_height(h):
	cell_height = h
	set_shape_height()

# SETTING PROPERTIES THROUGH INSPECTOR

func set_cell_width(w):
	if Engine.editor_hint:
		emit_signal("param_changed", "cell_width", w, self)
	else:
		cell_width = w

func set_aspect_ratio(e):
	if Engine.editor_hint:
		emit_signal("param_changed", "aspect_ratio", e)
	else:
		aspect_ratio = e

func set_cell_height(h):
	if Engine.editor_hint:
		emit_signal("param_changed", "cell_height", h, self)
	else:
		cell_height = h
	
# SETTING SHAPE DIMENSIONS

func set_shape(val):
	.set_shape(val)
	set_shape_width()
	set_shape_height()
	val.property_list_changed_notify()

func set_shape_width():
	match shape.get_class():
		"RectangleShape2D":
			set_rect_width()
		"CircleShape2D", "CapsuleShape2D":
			set_circle_r()
			
func set_shape_height():
	match shape.get_class():
		"RectangleShape2D", "CapsuleShape2D":
			set_rect_height()

func set_rect_width():
	shape.extents.x = cell_width/4

func set_rect_height():
	shape.extents.y = cell_height/4
	
func set_circle_r():
	shape.radius = cell_width/4
