extends Node2D

signal placed

enum GateTypes {AND, OR, XOR, NAND, NOR, XNOR, NOT}
@export var type: GateTypes
enum Directions {UP, DOWN, LEFT, RIGHT}
@export var direction: Directions = Directions.RIGHT
@export var carrying: bool = false

var current_inputs: Array[int] = []
var inputs_required: int = 2

@onready var output_location: Node2D = $OutputLocation

func _ready() -> void:
	if type == GateTypes.NOT:
		inputs_required = 1
	
	if direction == Directions.UP:
		output_location.position = Vector2(0, -1)
	elif direction == Directions.DOWN:
		output_location.position = Vector2(0, 1)
	elif direction == Directions.LEFT:
		output_location.position = Vector2(-1, 0)
	elif direction == Directions.RIGHT:
		output_location.position = Vector2(1, 0)
	output_location.position = output_location.position * 16
	
func _process(_delta: float) -> void:
	if carrying:
		global_position = get_global_mouse_position().snapped(Vector2(16, 16))
		
		if Input.is_action_just_pressed("place"):
			carrying = false
			placed.emit()


func make_sub_input(value: int) -> void:
	const INPUT: Resource = preload("res://input/input.tscn")
	var input: Node = INPUT.instantiate()
	
	input.value = value
	input.active = true
	input.direction = direction
	input.position = output_location.position
	call_deferred("add_child", input)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if "Laser" in area.name:
		current_inputs.append(area.get_parent().value)
	
	if len(current_inputs) != inputs_required:
		return
		
	match type:
		GateTypes.AND:
			var output: int = 0;
			if current_inputs[0] == 1 and current_inputs[1] == 1:
				output = 1
			make_sub_input(output)
		GateTypes.OR:
			var output: int = 0;
			if current_inputs[0] == 1 or current_inputs[1] == 1:
				output = 1
			make_sub_input(output)
		GateTypes.XOR:
			var output: int = 0;
			if current_inputs[0] != current_inputs[1]:
				output = 1
			make_sub_input(output)
		GateTypes.NAND:
			var output: int = 1;
			if current_inputs[0] == 1 and current_inputs[1] == 1:
				output = 0
			make_sub_input(output)
		GateTypes.NOR:
			var output: int = 0;
			if current_inputs[0] == 0 and current_inputs[1] == 0:
				output = 1
			make_sub_input(output)
		GateTypes.XNOR:
			var output: int = 1;
			if current_inputs[0] == current_inputs[1]:
				output = 0
			make_sub_input(output)
		GateTypes.NOT:
			var output: int = 1;
			if current_inputs[0] == 1:
				output = 0
			make_sub_input(output)
