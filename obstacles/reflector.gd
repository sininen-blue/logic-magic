extends Node2D

enum Directions {UP, DOWN, LEFT, RIGHT}
@export var direction: Directions = Directions.RIGHT

@onready var output_location: Node2D = $OutputLocation
@onready var sprite: Sprite2D = $Sprite2D


# TODO: feature to let multi directional inputs and outputs
# currenly only supports bottom to left, left to up, etc
func _ready() -> void:
	if direction == Directions.UP:
		sprite.region_rect = Rect2(80, 48, 16, 16)
		output_location.position = Vector2(0, -1)
	elif direction == Directions.DOWN:
		sprite.region_rect = Rect2(64, 48, 16, 16)
		output_location.position = Vector2(0, 1)
	elif direction == Directions.LEFT:
		output_location.position = Vector2(-1, 0)
	elif direction == Directions.RIGHT:
		sprite.region_rect = Rect2(80, 48, 16, 16)
	output_location.position = output_location.position * 16
	


func make_sub_input(value: int) -> void:
	const INPUT: Resource = preload("res://input/input.tscn")
	var input: Node = INPUT.instantiate()
	
	input.value = value
	input.direction = direction
	input.position = output_location.position
	call_deferred("add_child", input)


func _on_reflector_htibox_area_entered(area: Area2D) -> void:
	if "Laser" in area.name:
		make_sub_input(area.get_parent().value)
