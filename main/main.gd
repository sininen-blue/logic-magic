extends Node2D

const CELL_SIZE: int = 16

var inputs: Array[Node2D] = []
var outputs: Array[Node2D] = []

var input_width: int = 0
var output_width: int = 0
var goals: Array[Array] = []
var recieved_outputs: Dictionary[int, bool] = {}

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
	
	goals.append([1, 1, 1, 1, 1, 0]) # Hardcoded goals
	
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


func _on_output_received_input(output_id: int, correct: bool):
	recieved_outputs[output_id] = correct
	
	print(output_id)
	
	print(len(recieved_outputs), output_width)
	if len(recieved_outputs) != output_width:
		return
	
	var victory: bool = true
	for key in recieved_outputs:
		if recieved_outputs[key] == false:
			victory = false
		print("pre", victory)
	print("win?", victory)
