extends TileMap
tool

func _ready():
	pass # Replace with function body.

func set_cell_size(v2):
	# CONFIGURE SNAP > GRID STEP
	#	SET TO CELL_SIZE: VECTOR 2
	CanvasItemEditor.snap_step = v2
	
	# SET CELL SIZE
	cell_size = v2
	pass
