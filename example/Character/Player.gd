tool
extends PlayingPiece

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

func _ready():
	if !Engine.editor_hint:
		set_notify_transform(true)
		
		grid = get_parent()
	
		tween = $Tween
		tween.connect_into(self)
		turn(Vector2(0,1))

func _input(event):
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
			grid_x += direction.x
			grid_y += direction.y
			target_pos = get_position() + direction * Vector2(cell_width, cell_height)
			
			# ADD INCOMING BLOCK
			var new_incoming = incoming.instance()
			new_incoming.set_position(target_pos)
			grid.add_child(new_incoming)
			connect("incoming_gone", new_incoming, "queue_free")
			
			tween.move_char(self, target_pos)
			is_moving = true

func _on_tween_completed(o, k):
	is_moving = false
	emit_signal("incoming_gone")

func _on_area_entered(a):
	if a.get_parent() != $Position2D:
		blocks.append(a)
		is_blocked = true

func _on_area_exited(a):
	blocks.erase(a)
	is_blocked = blocks.size()

func turn(dir:Vector2):
	raycast = get_node(raycast_directions[dir])
