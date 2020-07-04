tool
extends EditorPlugin

# TO DO
#	GET UPPER TOOLBAR
#		ADDING: add_control_to_container()
#		ENUM: CONTAINER_CANVAS_EDITOR_MENU
#	GET SNAP PROPERTIES

func _enter_tree():
	# Initialization of the plugin goes here
	
	# 	Add the new type with a name, a parent type, a script and an icon
	#eg: add_custom_type("My Button", "Button", preload("my_button.gd"), preload("icon.png"))
	#		SIGNALS
	connect("scene_changed", self, "_on_scene_changed")
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
	print("nd")

func handles(TileMap):
	return true

func get_plugin_name():
	return "Snap Map"
