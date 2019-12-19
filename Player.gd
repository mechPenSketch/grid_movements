extends KinematicBody2D

var direction = Vector2()

var type
var grid

var speed = 0
const MAX_SPEED = 400

var is_moving = false
var tween
var target_pos = Vector2()

func _ready():
	grid = get_parent()
	type = grid.ENTITY_TYPES.PLAYER
	
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
		
	speed = 0 if direction == Vector2() else MAX_SPEED
	
	if !is_moving and direction != Vector2():
		target_pos = get_position() + direction * grid.tile_size
		tween.move_char(self, target_pos)
		is_moving = true
	pass
	
func _on_tween_completed(o, k):
	is_moving = false
	pass