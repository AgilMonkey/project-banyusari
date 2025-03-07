class_name Utility
extends Node


static func find_type(node: Node, type):
	for child in node.get_children():
		if is_instance_of(child, type):
			return child
	return null
