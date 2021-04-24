tool
extends EditorPlugin

# SAVE FILE
var config
const CONFIG_FILEPATH = "res://addons/snap_map/config.cfg"

# CLASSES
var current_node = null

# CANVAS SNAP SETTINGS
var save_file
var snap_dialog
var snap_spinbox
var snap_step_x
var snap_step_y
var snap_ratio
var snap_dialog_btn

signal input_event

func _enter_tree():
	
	# LOAD SNAP SETTING(S)
	config = ConfigFile.new()
	var err = config.load(CONFIG_FILEPATH)
	if err == OK:
		snap_step_x = config.get_value("snap", "step_x")
		snap_step_y = config.get_value("snap", "step_y")
		snap_ratio = config.get_value("snap", "ratio")
	
	# DEFINE SNAP SETTINGS
	set_snap_settings()
	
	# SELF-SIGNALS
	connect("scene_changed", self, "_on_scene_changed")
	get_tree().connect("node_added", self, "_on_node_added")

func _exit_tree():
	
	# SELF-SIGNALS
	disconnect("scene_changed", self, "_on_scene_changed")
	get_tree().disconnect("node_added", self, "_on_node_added")
	
	snap_dialog_btn.disconnect("pressed", self, "_on_snap_settings_confirmed")
	
func _on_node_added(n):
	
	# SET SNAP SETTINGS ONTO ADDED NODE
	set_node_params(n)

func _on_param_changed(param, val):
	match param:
		"cell_size":
			snap_spinbox[2].set_value(val.x)
			snap_spinbox[3].set_value(val.y)
			snap_dialog_btn.pressed()

func _on_scene_changed(scene_root):
	
	# KEEP PARAMETERS UP-TO-DATE
	set_node_params_then_children(get_tree().get_edited_scene_root())

func _on_snap_settings_confirmed():
	set_node_params_then_children(get_tree().get_edited_scene_root())

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
		if child is SpinBox:
			snap_spinbox.append(child)
			
		if child is Button and child.get_text() == "OK":
			snap_dialog_btn = child
			snap_dialog_btn.connect("pressed", self, "_on_snap_settings_confirmed")

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
	
	# IF NODE IS AFFECTED CLASS
	return node is SnapboundTiles

func recursive_get_children(node):
	var children = node.get_children()
	if children.size() == 0:
		return []
	else:
		for child in children:
			children += recursive_get_children(child)
		return children

# ON SAVING PROJECT
func save_external_data():
	# SET INTO CONFIG FILES
	config.set_value("snap", "step_x", snap_step_x)
	config.set_value("snap", "step_y", snap_step_y)
	config.set_value("snap", "ratio", snap_ratio)
	
	# OVERWRITTING FILE
	config.save(CONFIG_FILEPATH)

func set_node_params(node):
	# IF NODE IS SNAPBOUND TILES, SET ITS CELL SIZE BASED ON 	NEW SETTINGS
	if node is SnapboundTiles:
		node.cell_size = Vector2(snap_spinbox[2].get_value(), snap_spinbox[3].get_value())

func set_node_params_then_children(node):
	set_node_params(node)
	
	if node.get_child_count():
		for c in node.get_children():
			set_node_params_then_children(c)

func set_snap_step_l(param, val):
	match param:
		"cell_width":
			# SNAP STEP
			snap_step_x = val
			snap_spinbox[2].set_value(val)
			
			# OFFSET
			snap_spinbox[0].set_value(snap_step_x / 2)
		
		"cell_height":
			snap_step_y = val
			snap_spinbox[3].set_value(val)
			snap_spinbox[1].set_value(snap_step_y / 2)
	
	# SIMULATING PRESSING OK AFTER CONFIGURING SNAP SETTINGS
	snap_dialog.get_ok().emit_signal("pressed")

func set_snap_settings():
	find_snap_controls()
	
	# OFFSET
	snap_spinbox[0].set_value(snap_step_x / 2)
	snap_spinbox[1].set_value(snap_step_y / 2)
	
	# SNAP STEP
	snap_spinbox[2].set_value(snap_step_x)
	snap_spinbox[3].set_value(snap_step_y)
