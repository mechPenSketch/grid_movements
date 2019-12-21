extends Node2D

var direction = Vector2()
const DEG_UP = 0
const DEG_RIGHT = 90
const DEG_DOWN = 180
const DEG_LEFT = 270

var grid

var is_moving = false
var tween
var target_pos = Vector2()

func _ready():
	grid = get_parent()
	
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	
	tween = $Tween
	tween.connect_into(self)
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
		
		target_pos = get_position() + direction * grid.get_cell_size()
		tween.move_char(self, target_pos)
		is_moving = true
	pass
	
func _on_tween_completed(o, k):
	is_moving = false
	pass

func _on_area_entered(a):
	print("entered")
	pass

func _on_area_exited(a):
	print("exited")
	pass
	
func turn(dir:Vector2):
	if dir.y < 0:
		$Position2D.rotation_degrees = DEG_UP
	elif dir.x < 0:
		$Position2D.rotation_degrees = DEG_LEFT
	elif dir.x > 0:
		$Position2D.rotation_degrees = DEG_RIGHT
	else:
		$Position2D.rotation_degrees = DEG_DOWN
	pass