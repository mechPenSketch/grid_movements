tool
extends TileMap

class_name SnapboundTiles, "snapbound_tiles.svg"

export(Vector2) var children_offset setget set_children_offset, get_children_offset

# SETTING PARAM CHANGES
signal param_changed

# CLASS DATA

func get_class():
	return "SnapboundTiles"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)
	
# PROPERTIES DATA
func _set(property, value):
	# FOR PROPERTIES WHOSE SETTER CANNOT BE OVERRIDDEN
	if property == "cell_size":
		emit_signal("param_changed", "cell_size", value)

func get_children_offset():
	return children_offset
	
func set_children_offset(val):
	emit_signal("param_changed", "children_offset", val)
