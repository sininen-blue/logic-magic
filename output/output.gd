extends Node2D

@export var id: int = 0
@export var required_input: int = 0

signal received_input

func _on_output_hitbox_area_entered(area: Area2D) -> void:
	if "Laser" in area.name:
		var correct: bool = false
		if area.get_parent().value == required_input:
			correct = true
		received_input.emit(id, correct)
