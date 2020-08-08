tool
extends EditorPlugin

var affected_classes = ["SnapboundTiles", "PlayingPiece", "RayCastPiece", "ColShapePiece"]
var current_node = null

# CANVAS SNAP SETTINGS
var save_file
var snap_dialog
var snap_spinbox
var snap_offset_x
var snap_offset_y
var snap_step_x
var snap_step_y
var snap_ratio

func _enter_tree():
	# Initialization of the plugin goes here
	
	# ADD NODES UNIQUE TO THIS PLUGIN
	add_custom_type("SnapboundTiles", "TileMap", preload("classes/snapbound_tiles.gd"), preload("icons/snapbound_tiles.svg"))
	add_custom_type("PlayingPiece", "Area2D", preload("classes/playing_piece.gd"), preload("icons/playing_piece.svg"))
	add_custom_type("RayCastPiece", "RayCast2D", preload("classes/raycast_piece.gd"), preload("icons/raycast_piece.svg"))
	add_custom_type("CollisionShapePiece", "CollisionShape2D", preload("classes/colshape_piece.gd"), preload("icons/colshape_piece.svg"))
	
	# DEFINE SNAP SETTINGS
	set_snap_settings()
	
	# LOAD SNAP SETTING(S)
	save_file = preload("plugin_save.tres")
	snap_ratio = save_file.get_snap_ratio()
	pass


func _exit_tree():
	# Clean-up of the plugin goes here
	
	#	Always remember to remove it from the engine when deactivated
	remove_custom_type("SnapboundTiles")
	remove_custom_type("PlayingPiece")
	remove_custom_type("RayCastPiece")
	remove_custom_type("CollisionShapePiece")
	
	# SAVE SNAP SETTING(S)
	save_plugin()
	pass

func _on_param_changed(param, val):
	match param:
		"aspect_ratio":
			snap_ratio = val
		"cell_width", "cell_height":
			var prev_val = get_snap_step_l(param)
			set_snap_step_l(param, val)
			
			# AESPECT RATIO FACTOR
			if snap_ratio:
				var other_param = "cell_height" if param == "cell_width" else "cell_width"
				var other_val = val
				match snap_ratio:
					1:
						other_val = val
					2:
						other_val = current_node.get(other_param) * val / prev_val
				set_snap_step_l(other_param, other_val)
				set_nodes_params(get_tree().get_edited_scene_root(), other_param, other_val)
				
	# MASS SETTING PARAM TO ALL AFFECT NODES
	set_nodes_params(get_tree().get_edited_scene_root(), param, val)

# IF THIS PLUGIN handles(the_selected_node),
func edit(node):
	# IF NODE IS NOT ALREADY CONNECTED DUE TO edit(node) RUNNING MORE THAN ONCE
	if !node.is_connected("param_changed", self, "_on_param_changed"):
		# CONNECT SELECTED NODE
		node.connect("param_changed", self, "_on_param_changed")

func find_snap_controls():
	var base_control = get_editor_interface().get_base_control()
	var children = recursive_get_children(base_control)

	for i in children.size():
		var child = children[i]
		if child.get_class() == "SnapDialog":
			snap_dialog = child
	
	snap_spinbox = []
	for child in recursive_get_children(snap_dialog):
		if child.get_class() == "SpinBox":
			snap_spinbox.append(child)

func get_plugin_name():
	return "Snap Map"
			
func get_snap_step_l(param):
	match param:
		"cell_width":
			return snap_step_x
		"cell_height":
			return snap_step_y

# UPON A NODE BEING SELECTED,
#	 CHECKS WHETHER IT SHOULD BE AFFECTED BY THIS PLUGIN
func handles(node):
	if current_node != null:
		current_node.disconnect("param_changed", self, "_on_param_changed")
		current_node = null
	return affected_classes.has(node.get_class())

func recursive_get_children(node):
	var children = node.get_children()
	if children.size() == 0:
		return []
	else:
		for child in children:
			children += recursive_get_children(child)
		return children

func save_plugin():
	save_file.set_snap_ratio(snap_ratio)

# ON SCENE BEING CHANGED
func scene_changed():
	print("Scene is changed")

func set_nodes_params(node, param, val):
	if affected_classes.has(node.get_class()):
		match param:
			"aspect_ratio":
				node.plugset_aspect_ratio(val)
			"cell_width":
				node.plugset_cell_width(val)
			"cell_height":
				node.plugset_cell_height(val)
		
	if node.get_child_count():
		for c in node.get_children():
			set_nodes_params(c, param, val)

func set_snap_step_l(param, val):
	match param:
		"cell_width":
			snap_step_x = val
			snap_spinbox[2].set_value(val)
		"cell_height":
			snap_step_y = val
			snap_spinbox[3].set_value(val)
	
	# SIMULATING PRESSING OK AFTER CONFIGURING SNAP SETTINGS
	snap_dialog.get_ok().emit_signal("pressed")

func set_snap_settings():
	find_snap_controls()
	snap_offset_x = snap_spinbox[0].get_value()
	snap_offset_y = snap_spinbox[1].get_value()
	snap_step_x = snap_spinbox[2].get_value()
	snap_step_y = snap_spinbox[3].get_value()
