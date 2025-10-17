extends Node2D

enum GateTypes {AND, OR, XOR, NAND, NOR, XNOR, NOT}
@export var type: GateTypes
enum Directions {UP, DOWN, LEFT, RIGHT}
@export var direction: Directions = Directions.RIGHT
@export var inputs_required: int = 2

var current_inputs: Array[int] = []

@onready var output_location: Node2D = $OutputLocation

func _ready() -> void:
	if direction == Directions.UP:
		output_location.position = Vector2(0, -1)
	elif direction == Directions.DOWN:
		output_location.position = Vector2(0, 1)
	elif direction == Directions.LEFT:
		output_location.position = Vector2(-1, 0)
	elif direction == Directions.RIGHT:
		output_location.position = Vector2(1, 0)
	output_location.position = output_location.position * 16
	


func make_sub_input(value: int) -> void:
	const INPUT: Resource = preload("res://input/input.tscn")
	var input: Node = INPUT.instantiate()
	
	input.value = value
	input.direction = direction
	input.position = output_location.position
	call_deferred("add_child", input)


func _on_hitbox_area_entered(area: Area2D) -> void:
	print(area.name)
	if "Laser" in area.name:
		current_inputs.append(area.get_parent().value)
		
	print("aoriedjt")
	print(current_inputs)
	
	if len(current_inputs) != inputs_required:
		return
	print("calculating")
	print(type, GateTypes.AND)
	match type:
		GateTypes.AND:
			print("is an and gate")
			if current_inputs[0] == 1 and current_inputs[1] == 1:
				make_sub_input(1)
			# if both inputs are 1, make a new laser
