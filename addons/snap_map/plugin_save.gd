tool
extends Resource

class_name PluginSave

enum AspectRatio {NONE, SQUARE, KEEP}
export(AspectRatio) var snap_ratio = AspectRatio.SQUARE

func get_snap_ratio():
	return snap_ratio
	
func set_snap_ratio(sr):
	snap_ratio = sr
