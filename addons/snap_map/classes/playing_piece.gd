tool
extends Area2D

# SNAP SETTINGS
enum AspectRatio {NONE, SQUARE, KEEP}
export(int, 64) var cell_width setget set_cell_width
export(AspectRatio) var aspect_ratio setget set_aspect_ratio
export(int, 64) var cell_height setget set_cell_height

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
export (NodePath) var rayU
export (NodePath) var rayD
export (NodePath) var rayL
export (NodePath) var rayR
var raycast
export (Resource) var incoming
signal incoming_gone

func _ready():
	if !Engine.editor_hint:
		grid = get_parent()
	
		tween = $Tween
		tween.connect_into(self)
		turn(Vector2(0,1))
	pass

func _physics_process(delta):
	direction = Vector2()
		
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
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
	pass
	
func _on_tween_completed(o, k):
	is_moving = false
	emit_signal("incoming_gone")
	pass

func _on_area_entered(a):
	if a.get_parent() != $Position2D:
		print(a)
		blocks.append(a)
		is_blocked = true
	pass

func _on_area_exited(a):
	blocks.erase(a)
	is_blocked = blocks.size()
	pass

func get_class():
	return "PlayingPiece"
	
func turn(dir:Vector2):
	if dir.y < 0:
		raycast=get_node(rayU)
	elif dir.x < 0:
		raycast=get_node(rayL)
	elif dir.x > 0:
		raycast=get_node(rayR)
	else:
		raycast=get_node(rayD)
	pass

func set_cell_width(w):
	emit_signal("param_changed", "cell_width", w)

func set_aspect_ratio(e):
	emit_signal("param_changed", "aspect_ratio", e)

func set_cell_height(h):
	emit_signal("param_changed", "cell_height", h)
