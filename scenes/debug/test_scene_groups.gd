extends Node2D


func remove_from_group_in_function():
	var children = get_tree().get_nodes_in_group('test')
	var child : Node2D = children.pick_random()
	child.remove_from_group('test')
	var children_after = get_tree().get_nodes_in_group('test')
	prints(children,children_after)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var children = get_tree().get_nodes_in_group('test')
	#remove_from_group_in_function()
	var achild = children.pick_random()
	achild.remove_from_group_in_function()
	var children_after = get_tree().get_nodes_in_group('test')
	prints(children,children_after)
	if children.size() == children_after.size():
		prints("group members are the same!",children_after.size())
	else:
		prints("group members are different. All is well.")
