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
var base_tooltips = {}

func _enter_tree():
	
	# DEFINE SNAP SETTINGS
	var base_control = get_editor_interface().get_base_control()
	var children = recursive_get_children(base_control)
	
	#	ALONG THE WAY, FIND SCENE TREE INTERFACE
	var potential_trees = []
	
	for child in children:
		if child.get_class() == "SnapDialog":
			snap_dialog = child
		
		elif child is Tree:
			potential_trees.append(child)
			
	ui_scenetree = potential_trees[1]
	ui_scenetree.connect("gui_input", self, "_gui_scenetree_input")
	
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
	
	# RESET PLAYING PIECES' TOOLTIPS TO NORMAL
	for k in base_tooltips.keys():
		k.set_tooltip(0, base_tooltips[k])
	base_tooltips = {}
	
	# SELF-SIGNALS
	disconnect("scene_changed", self, "_on_scene_changed")
	get_tree().disconnect("node_added", self, "_on_node_added")
	
	snap_dialog_btn.disconnect("pressed", self, "_on_snap_settings_confirmed")

func _gui_scenetree_input(e):
	
	# IF THE INPUT EVENT IS MOUSE MOTION
	if e is InputEventMouseMotion:
		
		# GET THE TREE ITEM MOUSED OVER
		var tree_item = ui_scenetree.get_item_at_position(e.get_position())
		if tree_item:
			
			# FIND THE NODE IT REPRESENTS
			var cur_item = tree_item
			var root_item = ui_scenetree.get_root()
			var node_names = []
			
			while(cur_item != root_item):
				node_names.push_front(cur_item.get_text(0))
				cur_item = cur_item.get_parent()
				
			var node_path = ""
			for i in node_names.size():
				if i > 0: node_path += "/"
				node_path += node_names[i]
				
			if node_path:
				var node = get_tree().get_edited_scene_root().get_node(node_path)
				if node is PlayingPiece:
					
					# FIND GRID POSITION
					var grid_pos = node.grid_position
					if grid_pos != null:
						var tooltip_ln_grid_pos = "Grid Pos: " + String(grid_pos) + "\n"
						
						# STORE ORIGINAL TOOLTIP MESSAGE
						if !base_tooltips.has(tree_item):
							base_tooltips[tree_item] = tree_item.get_tooltip(0)
						
						# UPDATE TOOLTIP TO INCLUDE GRID POSITION
						var new_tooltip = tooltip_ln_grid_pos + base_tooltips[tree_item]
						tree_item.set_tooltip(0, new_tooltip)

func _on_node_added(n):
	
	if n is SnapboundTiles:
		if snaps_not_loaded():
			# SET SNAP SETTINGS BASED ON GIVEN SNAPBOUND TILES
			
			#	OFFSET
			var children_offset = n.get_children_offset()
			snap_spinbox[0].set_value(children_offset.x)
			snap_spinbox[1].set_value(children_offset.y)
			
			#	SNAP STEP
			var cell_size = n.get_cell_size()
			snap_spinbox[2].set_value(cell_size.x)
			snap_spinbox[3].set_value(cell_size.y)
			
			set_snap_settings(cell_size, children_offset)
		else:
			# APPLY SNAP SETTINGS ONTO ADDED NODE
			set_sbt_params(n)
		
		n.connect("settings_changed", n, "_settings_changed")
		
	elif n is PlayingPiece:
		n.set_parent_tilemap(get_parent_tilemap(n))

func _on_param_changed(param, val):
	match param:
		"cell_size":
			snap_spinbox[2].set_value(val.x)
			snap_spinbox[3].set_value(val.y)
			snap_dialog_btn.emit_signal("pressed")
		"children_offset":
			snap_spinbox[0].set_value(val.x)
			snap_spinbox[1].set_value(val.y)
			snap_dialog_btn.emit_signal("pressed")

func _on_scene_changed(scene_root):
	
	# EMPTY BASE TOOLTIPS
	base_tooltips = {}
	
	# IF SNAP SETTINGS HAVE BEEN CALLED EARLIER
	if !snaps_not_loaded():
		# KEEP PARAMETERS UP-TO-DATE
		set_sbt_params_then_children(get_tree().get_edited_scene_root(), "SnapboundTiles")

func _on_snap_settings_confirmed():
	set_sbt_params_then_children(get_tree().get_edited_scene_root(), "SnapboundTiles")
	set_snap_settings(Vector2(snap_spinbox[2].get_value(), snap_spinbox[3].get_value()), Vector2(snap_spinbox[0].get_value(), snap_spinbox[1].get_value()))

# IF THIS PLUGIN handles(the_selected_node),
func edit(node):
	
	# IF NODE IS NOT ALREADY CONNECTED DUE TO edit(node) RUNNING MORE THAN ONCE
	if !node.is_connected("param_changed", self, "_on_param_changed"):
		
		# CONNECT SELECTED NODE
		node.connect("param_changed", self, "_on_param_changed")
		
	# SET CURRENT NODE
	current_node = node

func get_parent_tilemap(node):
	if node is TileMap:
		return node
	else:
		var parent = node.get_parent()
		if parent:
			return get_parent_tilemap(parent)
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

func set_sbt_params(node):
	# IF NODE IS SNAPBOUND TILES
	if node is SnapboundTiles:
		
		if node != current_node:
			# SET ITS CELL SIZE BASED ON NEW SETTINGS
			node.plugset_cell_size(snap_grid_step)
		
			# THEN CHILDREN OFFSET
			node.plugset_children_offset(snap_grid_offset)

func set_sbt_params_then_children(node, cn, sp=null):
	# INPUTS:
	#	NODE
	#	CLASS NAME
	#	STARTING PARENT (DEFAULT: NULL)
	
	match cn:
		"SnapboundTiles":
			set_sbt_params(node)
	
	if node.get_child_count():
		for c in node.get_children():
			set_sbt_params_then_children(c, cn, sp)

func set_snap_settings(step, offset = Vector2(0, 0)):
	# OFFSET
	snap_grid_offset = offset
	
	# SNAP STEP
	snap_grid_step = step

func snaps_not_loaded()->bool:
	return snap_grid_step == DEFAULT_STEP
