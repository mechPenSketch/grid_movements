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
	
func _settings_changed():
	# FOR PROPERTIES WHOSE SETTER CANNOT BE OVERRIDDEN, CALL FROM THIS SIGNAL INSTEAD
	emit_signal("param_changed", "cell_size", get_cell_size())

func get_children_offset():
	return children_offset

func plugset_cell_size(val):
	cell_size = val

func plugset_children_offset(val):
	children_offset = val

func set_children_offset(val):
	children_offset = val
	emit_signal("param_changed", "children_offset", val)
