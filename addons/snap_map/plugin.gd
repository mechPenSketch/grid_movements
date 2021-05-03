tool
extends EditorPlugin

# CLASSES
var current_node = null

# CANVAS SNAP SETTINGS
var snap_dialog
var snap_spinbox
const DEFAULT_OFFSET = Vector2()
const DEFAULT_STEP = Vector2(0.01, 0.01)
var snap_grid_step = DEFAULT_STEP
var snap_grid_offset = DEFAULT_OFFSET
var snap_dialog_btn

var ui_scenetree

signal input_event

func _about_to_show_snapdialog():
	if snaps_not_loaded():
		# GET THE FIRST SNAPBOUND_TILES FROM SCENE TREE
		var first_snapbound_tiles = get_first_snapbound_tiles(get_tree().get_edited_scene_root())
	
		# IF ANY, SET SNAP SETTINGS BASED ON THE FIRST SNAPBOUND_TILES
		if first_snapbound_tiles:
			# OFFSET
			var offset = first_snapbound_tiles.get_children_offset()
			snap_spinbox[0].set_value(offset.x)
			snap_spinbox[1].set_value(offset.y)
			
			# SNAP STEP
			var step = first_snapbound_tiles.get_cell_size()
			snap_spinbox[2].set_value(step.x)
			snap_spinbox[3].set_value(step.y)
			
			set_snap_settings(step, offset)
		
		# OTHERWISE, USE RECENTLY-SET SNAP SETTINGS
		else:
			set_snap_settings(Vector2(snap_spinbox[2].get_value(), snap_spinbox[3].get_value()), Vector2(snap_spinbox[0].get_value(), snap_spinbox[1].get_value()))

func _enter_tree():
	
	# DEFINE SNAP SETTINGS
	var base_control = get_editor_interface().get_base_control()
	var children = recursive_get_children(base_control)
	
	for child in children:
		if child.get_class() == "SnapDialog":
			snap_dialog = child
			snap_dialog.connect("about_to_show", self, "_about_to_show_snapdialog")
			
		elif child.get_class() == "SceneTreeDock":
			ui_scenetree = child.get_child(child.get_child_count() - 1)
	
	snap_spinbox = []
	for child in recursive_get_children(snap_dialog):
		if child is SpinBox:
			snap_spinbox.append(child)
			
		if child is Button and child.get_text() == "OK":
			snap_dialog_btn = child
			snap_dialog_btn.connect("pressed", self, "_on_snap_settings_confirmed")
	
	# SELF-SIGNALS
	connect("scene_changed", self, "_on_scene_changed")
	get_tree().connect("node_added", self, "_on_node_added")

func _exit_tree():
	
	# SELF-SIGNALS
	disconnect("scene_changed", self, "_on_scene_changed")
	get_tree().disconnect("node_added", self, "_on_node_added")
	
	snap_dialog_btn.disconnect("pressed", self, "_on_snap_settings_confirmed")

func _on_node_added(n):
	
	if !snaps_not_loaded():
		# SET SNAP SETTINGS ONTO ADDED NODE
		set_node_params(n)
	
	"""
	if n is PlayingPiece:
		for t in trees:
			var le_root=t.get_root()
			if le_root:
				var me_children = le_root.get_children()
				if me_children:
					print(me_children.get_text(0))
					#print(me_children.get_tooltip(0))
					#print(le_root.get_children().get_tooltip())
	"""

func _on_param_changed(param, val):
	match param:
		"cell_size":
			snap_spinbox[2].set_value(val.x)
			snap_spinbox[3].set_value(val.y)
		"children_offset":
			snap_spinbox[0].set_value(val.x)
			snap_spinbox[1].set_value(val.y)
			
	snap_dialog_btn.emit_signal("pressed")

func _on_scene_changed(scene_root):
	
	# IF SNAP SETTINGS HAVE BEEN CALLED EARLIER
	if snaps_not_loaded():
		set_snaps_from_first_snapbound()
	
	else:
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

func get_first_snapbound_tiles(node):
	if node is SnapboundTiles:
		return node
	else:
		if node.get_child_count():
			for c in node.get_children():
				get_first_snapbound_tiles(c)
		else:
			return null

func get_plugin_name():
	return "Snap Map"

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

func set_node_params(node):
	# IF NODE IS SNAPBOUND TILES
	if node is SnapboundTiles:
		# SET ITS CELL SIZE BASED ON NEW SETTINGS
		node.cell_size = snap_grid_step

func set_node_params_then_children(node):
	set_node_params(node)
	
	if node.get_child_count():
		for c in node.get_children():
			set_node_params_then_children(c)

func set_snap_settings(step, offset = Vector2(0, 0)):
	# OFFSET
	snap_grid_offset = offset
	
	# SNAP STEP
	snap_grid_step = step

func set_snaps_from_first_snapbound():
	
	# GET THE FIRST SNAPBOUND_TILES FROM SCENE TREE
	var first_snapbound_tiles = get_first_snapbound_tiles(get_tree().get_edited_scene_root())
	
	# IF ANY, SET SNAP SETTINGS BASED ON THE FIRST SNAPBOUND_TILES
	if first_snapbound_tiles:
		set_snap_settings(first_snapbound_tiles.get_cell_size(), first_snapbound_tiles.get_children_offset())

func snaps_not_loaded()->bool:
	return snap_grid_step == DEFAULT_STEP
