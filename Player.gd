extends Area2D

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

func _ready():
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
			tween.move_char(self, target_pos)
			is_moving = true
	pass
	
func _on_tween_completed(o, k):
	is_moving = false
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