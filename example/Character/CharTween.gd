extends Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func connect_into(o):
	connect("tween_completed", o, "_on_tween_completed")
	pass

func move_char(c, t_pos):
	interpolate_property(c, "position", c.get_position(), t_pos, 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	start()
	pass
