tool
extends TileMap

class_name SnapboundTiles

enum AspectRatio {NONE, SQUARE, KEEP}
export(int, 64) var cell_width setget set_cell_width
export(AspectRatio) var aspect_ratio setget set_aspect_ratio
export(int, 64) var cell_height setget set_cell_height

signal param_changed

func get_class():
	return "SnapboundTiles"

func set_cell_width(w):
	emit_signal("param_changed", "cell_width", w)

func set_aspect_ratio(e):
	emit_signal("param_changed", "aspect_ratio", e)

func set_cell_height(h):
	emit_signal("param_changed", "cell_height", h)
