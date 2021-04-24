tool
extends TileMap

class_name SnapboundTiles, "snapbound_tiles.svg"

# SETTING PARAM CHANGES
signal param_changed

# CLASS DATA

func get_class():
	return "SnapboundTiles"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)
