extends Node2D

const CELL_SIZE: int = 16

var inputs: Array[Node2D] = []
var outputs: Array[Node2D] = []

func _ready() -> void:
	var children = self.get_children()
	for child in children:
		if "Input" in child.name:
			inputs.append(child)
		if "Output" in child.name:
			outputs.append(child) 
	
	for input in inputs:
		input.connect("collided", _on_input_hit)


func _on_input_hit(shooter, value, target) -> void:
	if "output" in target:
		print(target, value)
