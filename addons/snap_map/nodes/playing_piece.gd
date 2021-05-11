tool
extends Area2D

class_name PlayingPiece, "playing_piece.svg"

var parent_tilemap
var grid_position = null

# CLASS DATA

func get_class():
	return "PlayingPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)

# PROPERTY METHODS

func set_parent_tilemap(n):	
	# IF ANY, CUT TIES TO FORMER PARENT TILEMAP
	if parent_tilemap:
		parent_tilemap.disconnect("settings_changed", self, "_parent_tilemap_settings_changed")
	
	if n is TileMap:
		parent_tilemap = n
		parent_tilemap.connect("settings_changed", self, "_parent_tilemap_settings_changed")
		
		if grid_position:
			reposition()
		else:
			grid_position = parent_tilemap.world_to_map(get_global_position())
	else:
		parent_tilemap = null
		grid_position = null

# METHODS

func _parent_tilemap_settings_changed():
	reposition()

func reposition():
	# SET POSITION FROM GRID
	var mtw = parent_tilemap.map_to_world(grid_position)
	
	# THEN APPLY OFFSET
	var final_pos = mtw + parent_tilemap.children_offset
	
	set_global_position(final_pos)
	
	# SETTING ITS CHILDREN COMPONENETS
	for c in get_children():
		if c.is_class("RayCastPiece"):
			c.set_direction(parent_tilemap.get_cell_size())
		elif c.is_class("ColShapePieceEx"):
			pass
