extends KinematicBody2D

var direction = Vector2()

var type
var grid

var speed = 0
const MAX_SPEED = 400

var is_moving = false
var target_pos = Vector2()
var target_direction = Vector2()

func _ready():
	grid = get_parent()
	type = grid.ENTITY_TYPES.PLAYER
	pass

func _physics_process(delta):
	direction = Vector2()
		
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1
		
	speed = 0 if direction == Vector2() else MAX_SPEED
	
	if !is_moving and direction != Vector2():
		target_direction = direction
		if grid.is_cell_vacant(get_position(), direction):
			target_pos = grid.update_child_pos(self)
			is_moving = true
	elif is_moving:
		speed = MAX_SPEED
		var velocity = speed * target_direction.normalized() * delta
		move_and_collide(velocity)
		
		var pos = get_position()
		var distance_to_target = Vector2(abs(target_pos.x - pos.x), abs(target_pos.y - pos.y))
		
		if abs(velocity.x) > distance_to_target.x:
			velocity.x = distance_to_target.x * target_direction.x
			is_moving = false
			
		if abs(velocity.y) > distance_to_target.y:
			velocity.y = distance_to_target.y * target_direction.y
			is_moving = false
	pass