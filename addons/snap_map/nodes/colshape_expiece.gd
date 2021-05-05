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
				#set_anchor_pos_x()
				pass
			
			# VERTICAL ALIGN COMPARISON
			if prev_val / 3 != val / 3:
				#set_anchor_pos_y()
				pass
		
	if prev_val != val:
		property_list_changed_notify()
		shape.property_list_changed_notify()
	
func set_grid_width(val):
	if val > 0:
		grid_width = val
		#set_shape_width()

func set_grid_height(val):
	if val > 0:
		grid_height = val
		#set_shape_height()
		
"""
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
"""
