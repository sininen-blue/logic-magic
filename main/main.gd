extends Node2D

const CELL_SIZE: int = 16

var inputs: Array[Node2D] = []
var outputs: Array[Node2D] = []

var input_width: int = 0
var output_width: int = 0
var goals: Array[Array] = []
var recieved_outputs: Dictionary[int, bool] = {}

var is_carrying: bool = false

func _ready() -> void:
	var input_id: int = 0
	var output_id: int = 0
	var children = self.get_children()
	for child in children:
		if "Input" in child.name:
			child.id = input_id
			input_id += 1
			inputs.append(child)
		if "Output" in child.name:
			child.id = output_id
			output_id += 1
			outputs.append(child) 
	
	input_width = len(inputs)
	output_width = len(outputs)
	
	goals.append([1, 1, 1]) # Hardcoded goals
	
	for goal_index in range(len(goals)):
		var row_goal: Array = goals[goal_index]
		var row_inputs: Array = row_goal.slice(0, input_width)
		var row_outputs: Array = row_goal.slice(input_width, len(row_goal))
		
		for input_index in range(len(inputs)):
			inputs[input_index].value = row_inputs[input_index]
		
		for output_index in range(len(outputs)):
			outputs[output_index].required_input = row_outputs[output_index]
	
	for output in outputs:
		output.connect("received_input", _on_output_received_input)


func make_gate(type: int) -> void:
	const GATE: Resource = preload("res://gate/gate.tscn")
	var gate: Node = GATE.instantiate()
	
	gate.type = type
	gate.carrying = true
	gate.connect("placed", _on_gate_placed)
	is_carrying = true
	call_deferred("add_child", gate)


func _on_gate_placed():
	is_carrying = false


func _on_output_received_input(output_id: int, correct: bool):
	recieved_outputs[output_id] = correct
	
	if len(recieved_outputs) != output_width:
		return
	
	var victory: bool = true
	for key in recieved_outputs:
		if recieved_outputs[key] == false:
			victory = false
		print("pre", victory)
	print("win?", victory)


# hardcoded gate ids, bad but good enough
func _on_ui_create(type: String) -> void:
	if is_carrying:
		return
	
	match type:
		"and":
			make_gate(0)
		"or":
			make_gate(1)
		"xor":
			make_gate(2)
		"nand":
			make_gate(3)
		"nor":
			make_gate(4)
		"xnor":
			make_gate(5)
		"not":
			make_gate(6)


func _on_ui_start() -> void:
	for input in inputs:
		input.active = true
