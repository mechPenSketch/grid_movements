tool
extends ColShapePiece

class_name ColShapePieceEx, "colshape_expiece.svg"

enum Anchors {TOPLEFT, TOP, TOPRIGHT, LEFT, CENTER, RIGHT, BOTTOMLEFT, BOTTOM, BOTTOMRIGHT}
export(Anchors) var anchor = Anchors.CENTER setget set_anchor
export(int) var grid_width:int = 1 setget set_grid_width
export(int) var grid_height:int = 1 setget set_grid_height

# SETTING PROPERTIES THROUGH INSPECTOR

func set_anchor(val):
	var prev_val = anchor
	anchor = val
	
	match shape.get_class():
		_:
			# HORIZONTAL ALIGN COMPARISON
			if prev_val % 3 != val % 3:
				set_anchor_pos_x()
			
			# VERTICAL ALIGN COMPARISON
			if prev_val / 3 != val / 3:
				set_anchor_pos_y()
		
	if prev_val != val:
		property_list_changed_notify()
		shape.property_list_changed_notify()
	
func set_grid_width(val):
	if val > 0:
		grid_width = val
		set_shape_width()

func set_grid_height(val):
	if val > 0:
		grid_height = val
		set_shape_height()

# SHAPES DATA

func is_not_aligned_center_x():
	return anchor % 3 != 1

func is_not_aligned_center_y():
	return anchor / 3 != 1

func set_rect_width():
	shape.extents.x = cell_width / 2 * (grid_width - 0.5)
	if is_not_aligned_center_x():
		set_anchor_pos_x()

func set_rect_height():
	shape.extents.y = cell_height / 2 * (grid_height - 0.5)
	if is_not_aligned_center_y():
		set_anchor_pos_y()
	
func set_circle_r():
	shape.radius = cell_width / 2 * (grid_width - 0.5)
	if is_not_aligned_center_x():
		set_anchor_pos_x()

func set_anchor_pos_x():
	match anchor % 3:
		1:
			# MIDDLE
			position.x = 0
		2:
			# RIGHT
			position.x = cell_width / 4 - get_half_width()
		_:
			# LEFT
			position.x = get_half_width() - cell_width / 4

func set_anchor_pos_y():
	match anchor / 3:
		1:
			# MIDDLE
			position.y = 0
		2:
			# BOTTOM
			position.y = cell_height / 4 - get_half_height()
		_:
			# TOP
			position.y = get_half_height() - cell_height / 4
