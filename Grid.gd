extends TileMap

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

enum ENTITY_TYPES {PLAYER, OBSTACLE, COLLECTABLE}

var grid_size = Vector2(16, 16)
var grid = []

onready var Obstacle = preload("res://Obstacle.tscn")

func _ready():
	
	# Create Grid Array
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	
	# Create Obstacles
	var positions = []
	for n in range(5):
		var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not grid_pos in positions:
			positions.append(grid_pos)
	
	for pos in positions:
		var new_obstacle = Obstacle.instance()
		new_obstacle.set_position(map_to_world(pos) + half_tile_size)
		grid[pos.x][pos.y] = ENTITY_TYPES.OBSTACLE
		add_child(new_obstacle)
	pass

func is_cell_vacant(pos, dir) -> bool:
	
	var grid_pos = world_to_map(pos) + dir
	
	# If target is in grid range
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
		
			# Return T if target has nothing
			return grid[grid_pos.x][grid_pos.y] == null
	
	return false
	
	pass
	
func update_child_pos(child_node):
	# Move a child to a new position in the grid array
	# Returns the new target world position of the child
	var grid_pos = world_to_map(child_node.get_position())
	print(grid_pos)
	
	# Set child's current position to null
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type
	
	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	return target_pos
	pass