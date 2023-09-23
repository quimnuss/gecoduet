extends Node

class_name DebugGlobals

var debug_show_paths : bool = false
var debug_show_label : bool = false

signal globals_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_debug_label"):
		debug_show_label = !debug_show_label
		globals_changed.emit()

	if event.is_action_pressed("ui_debug_navigation"):
		debug_show_paths = !debug_show_paths
		globals_changed.emit()
