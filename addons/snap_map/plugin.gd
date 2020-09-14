tool
extends EditorPlugin

# SAVE FILE
var config
const CONFIG_FILEPATH = "res://addons/snap_map/config.cfg"

# CLASSES
var affected_classes = ["SnapboundTiles", "RayCastPiece", "ColShapePiece", "PlayingPiece"]
var current_node = null

# CANVAS SNAP SETTINGS
var save_file
var snap_dialog
var snap_spinbox
var snap_step_x
var snap_step_y
var snap_ratio

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
	
	# SIGNALS FROM OTHER NODES
	disconnect_node_then_children(get_tree().get_edited_scene_root(), "input_event", affected_classes[3], "_plugin_input")
	
func _input(event):
	emit_signal("input_event", event)
	
func _on_node_added(n):
	
	# SET SNAP SETTINGS ONTO ADDED NODE
	set_node_params(n, "aspect_ratio", snap_ratio)
	set_node_params(n, "cell_width", snap_step_x)
	set_node_params(n, "cell_height", snap_step_y)
	
	# CONNECT NODE
	connect_node(n, "input_event", affected_classes[3], "_plugin_input")

func _on_param_changed(param, val, fc_nd=null):
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
				set_node_params_then_children(get_tree().get_edited_scene_root(), other_param, other_val)
				fc_nd.property_list_changed_notify()
				
	# MASS SETTING PARAM TO ALL AFFECT NODES
	set_node_params_then_children(get_tree().get_edited_scene_root(), param, val)

func _on_scene_changed(scene_root):
	
	# KEEP PARAMETERS UP-TO-DATE
	set_node_params_then_children(get_tree().get_edited_scene_root(), "aspect_ratio", snap_ratio)
	set_node_params_then_children(get_tree().get_edited_scene_root(), "cell_width", snap_step_x)
	set_node_params_then_children(get_tree().get_edited_scene_root(), "cell_height", snap_step_y)
	
	# MASS CONNECT NODES
	connect_node_then_children(get_tree().get_edited_scene_root(), "input_event", affected_classes[3], "_plugin_input")

func connect_node(n, s, c, m):
	if n.is_class(c):
		if !is_connected(s, n, m):
			connect(s, n, m)
	
func connect_node_then_children(n, s, c, m):
	connect_node(n, s, c, m)
	
	if n.get_child_count():
		for ch in n.get_children():
			connect_node_then_children(ch, s, c, m)

func disconnect_node(n, s, c, m):
	if n.is_class(c):
		if is_connected(s, n, m):
			disconnect(s, n, m)
	
func disconnect_node_then_children(n, s, c, m):
	disconnect_node(n, s, c, m)
	
	if n.get_child_count():
		for ch in n.get_children():
			disconnect_node_then_children(ch, s, c, m)

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
	
	# IF NODE IS OR INHERITS FROM AFFECT CLASS
	for str_cls in affected_classes:
		if node.is_class(str_cls):
			return true
	return false

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

func set_node_params(node, param, val):
	# IF NODE IS OR INHERITS FROM AFFECT CLASS
	for str_cls in affected_classes:
		if node.is_class(str_cls):
			match param:
				"aspect_ratio":
					node.plugset_aspect_ratio(val)
				"cell_width":
					node.plugset_cell_width(val)
				"cell_height":
					node.plugset_cell_height(val)
			break

func set_node_params_then_children(node, param, val):
	set_node_params(node, param, val)
	
	if node.get_child_count():
		for c in node.get_children():
			set_node_params_then_children(c, param, val)

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
