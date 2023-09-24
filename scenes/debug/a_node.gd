extends Node2D

class_name ANode

func _ready():
	self.add_to_group('test')

func remove_from_group_in_function():
	var children = get_tree().get_nodes_in_group('test')
	self.remove_from_group('test')
	var children_after = get_tree().get_nodes_in_group('test')
	prints(children,children_after)
