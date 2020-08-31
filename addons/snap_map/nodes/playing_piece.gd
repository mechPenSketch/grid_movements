tool
extends Area2D

class_name PlayingPiece, "playing_piece.svg"

# SNAP SETTINGS
enum AspectRatio {NONE, SQUARE, KEEP}
export(int) var cell_width = 64 setget set_cell_width
export(AspectRatio) var aspect_ratio = AspectRatio.SQUARE setget set_aspect_ratio
export(int) var cell_height = 64 setget set_cell_height
export(int) var grid_x setget set_grid_x
export(int) var grid_y setget set_grid_y
var input_event

# INDIVIDUAL PARAMETERS
var direction = Vector2()
const DEG_UP = 0
const DEG_RIGHT = 90
const DEG_DOWN = 180
const DEG_LEFT = 270

var grid

var is_moving = false
var tween
var target_pos = Vector2()
var blocks = []
var is_blocked:bool = false
export (Dictionary) var raycast_directions
var raycast
export (Resource) var incoming
signal incoming_gone

# SETTING PARAM CHANGES
signal param_changed

func _ready():
	if !Engine.editor_hint:
		set_notify_transform(true)
		
		grid = get_parent()
	
		tween = $Tween
		tween.connect_into(self)
		turn(Vector2(0,1))
	pass

func _input(event):
	if !Engine.editor_hint:
		direction = Vector2()
			
		if event.is_action_pressed("ui_up"):
			direction.y -= 1
		elif event.is_action_pressed("ui_down"):
			direction.y += 1
		elif event.is_action_pressed("ui_left"):
			direction.x -= 1
		elif event.is_action_pressed("ui_right"):
			direction.x += 1
		
		if !is_moving and direction != Vector2():
			
			turn(direction)
			
			if !raycast.is_colliding():
				target_pos = get_position() + direction * grid.get_cell_size()
				
				# ADD INCOMING BLOCK
				var new_incoming = incoming.instance()
				new_incoming.set_position(target_pos)
				grid.add_child(new_incoming)
				connect("incoming_gone", new_incoming, "queue_free")
				
				tween.move_char(self, target_pos)
				is_moving = true

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if input_event is InputEventMouseButton:
			if !input_event.is_pressed():
				# SET GRID POSITION
				grid_x = int(position.x) / cell_width
				grid_y = int(position.y) / cell_width

func _on_tween_completed(o, k):
	is_moving = false
	emit_signal("incoming_gone")
	pass

func _on_area_entered(a):
	if a.get_parent() != $Position2D:
		blocks.append(a)
		is_blocked = true
	pass

func _on_area_exited(a):
	blocks.erase(a)
	is_blocked = blocks.size()
	pass

func _plugin_input(e):
	input_event = e

# CLASS NAME

func get_class():
	return "PlayingPiece"

func is_class(s)->bool:
	return s == get_class() or .is_class(s)

# SETTING PROPERTIES THROUGH PLUGIN

func plugset_cell_width(w):
	cell_width = w
	set_pos_x()

func plugset_aspect_ratio(e):
	aspect_ratio = e
	
func plugset_cell_height(h):
	cell_height = h
	set_pos_y()

# SETTING PROPERTIES THROUGH INSPECTOR

func set_cell_width(w):
	emit_signal("param_changed", "cell_width", w)

func set_aspect_ratio(e):
	emit_signal("param_changed", "aspect_ratio", e)

func set_cell_height(h):
	emit_signal("param_changed", "cell_height", h)

func set_grid_x(gx):
	grid_x = gx
	set_pos_x()
	
func set_grid_y(gy):
	grid_y = gy
	set_pos_y()

# TO BE OVERRIDDEN TO ACCOUNT FOR GRID POSITIONS
func set_global_position(value):
	print(value)
	"""
	# ROUNDING
	var cell_lengths = [cell_width, cell_height]
	for i in v2.size():
		# GET THE LENGTH TO BE USED
		var l = cell_lengths[i]
		
		# GET REMAINDER
		var r = v2[i] % l
		
		# GET MID-POINT
		var m = l / 2
		if r < m:
			# ROUND TO PREVIOUS MID-POINT
			var diff = m - r
			cell_lengths[i] += diff
		elif r > m:
			# ROUND TO NEXT MID-POINT
			var diff = r - m
			cell_lengths[i] -= diff
	print(v2)
	"""
	grid_x = int(position.x) / cell_width
	grid_y = int(position.y) / cell_width
	.set_global_position(value)

func set_pos_x():
	position.x = (grid_x + 0.5) * cell_width
	
func set_pos_y():
	position.y = (grid_y + 0.5) * cell_height

func turn(dir:Vector2):
	raycast = get_node(raycast_directions[dir])
