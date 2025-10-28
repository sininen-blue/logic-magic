extends Node2D

signal received_input

@export var id: int = 0
@export var required_input: int = 0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if required_input == 1:
		sprite.region_rect = Rect2(0.0, 64.0, 32.0, 16.0)
	else:
		sprite.region_rect = Rect2(0.0, 80, 32.0, 16.0)

func _on_output_hitbox_area_entered(area: Area2D) -> void:
	if "Laser" in area.name:
		var correct: bool = false
		if area.get_parent().value == required_input:
			correct = true
		received_input.emit(id, correct)
