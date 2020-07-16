tool
extends EditorPlugin

# TO DO
#	GET UPPER TOOLBAR
#		ADDING: add_control_to_container() / get_editor_interface ()
#		ENUM: CONTAINER_CANVAS_EDITOR_MENU
#	FIND CanvasItemEditor
#		get_editor_interface().get_base_control() > Find snap?
#	GET SNAP PROPERTIES

# CANVAS SNAP SETTINGS
var snap_spinbox

var snap_offset
var snap_step

func _enter_tree():
	# Initialization of the plugin goes here
	
	# 	Add the new type with a name, a parent type, a script and an icon
	#eg: add_custom_type("My Button", "Button", preload("my_button.gd"), preload("icon.png"))
	#		SIGNALS
	connect("scene_changed", self, "_on_scene_changed")
	
	#		DEFINE SNAP SETTINGS
	update_snap_settings()
	pass


func _exit_tree():
	# Clean-up of the plugin goes here
	
	#	Always remember to remove it from the engine when deactivated
	#eg: remove_custom_type("My Button")
	#		SIGNALS
	disconnect("scene_changed", self, "_on_scene_changed")
	pass

func _on_scene_changed(scene_root:Node):
	pass

func edit(TileMap):
	pass

func handles(TileMap):
	return true

func get_plugin_name():
	return "Snap Map"

func recursive_get_children(node):
	var children = node.get_children()
	if children.size() == 0:
		return []
	else:
		for child in children:
			children += recursive_get_children(child)
		return children

func find_snap_controls():
	var base_control = get_editor_interface().get_base_control()
	var children = recursive_get_children(base_control)

	#var snap_dialog = children[1728]
	var snap_dialog
	for i in children.size():
		var child = children[i]
		if child.get_class() == "SnapDialog":
			snap_dialog = child
	
	snap_spinbox = []
	for child in recursive_get_children(snap_dialog):
		if child.get_class() == "SpinBox":
			snap_spinbox.append(child)

func update_snap_settings():
	find_snap_controls()
	snap_offset = Vector2(snap_spinbox[0].get_value(), snap_spinbox[1].get_value())
	snap_step = Vector2(snap_spinbox[2].get_value(), snap_spinbox[3].get_value())
