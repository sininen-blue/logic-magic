extends Node2D


@export var id: int = 0
enum Directions {UP, DOWN, LEFT, RIGHT}
@export var direction: Directions = Directions.RIGHT
@export var value: int = 0
@export var speed: float = 64
@export var active: bool = false

var laser_path: PackedVector2Array = []
var moving: bool = true

@onready var laser: Line2D = $Laser
@onready var laser_hitbox: Area2D = $LaserHitbox
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	if direction == Directions.UP:
		sprite.region_rect = Rect2(64, 32, 16, 16)
		laser_hitbox.position = Vector2(0, -1)
	elif direction == Directions.DOWN:
		sprite.region_rect = Rect2(48, 32, 16, 16)
		laser_hitbox.position = Vector2(0, 1)
	elif direction == Directions.LEFT:
		sprite.region_rect = Rect2(32, 32, 16, 16)
		laser_hitbox.position = Vector2(-1, 0)
	elif direction == Directions.RIGHT:
		sprite.region_rect = Rect2(32, 32, 16, 16)
		laser_hitbox.position = Vector2(1, 0)
	laser_hitbox.position = laser_hitbox.position * 16
		
	laser_path.append(Vector2.ZERO)
	laser.points = laser_path

func _process(delta: float) -> void:
	if moving and active:
		var next_position: Vector2 = laser_path[-1] + laser_hitbox.position.normalized() * speed * delta
		
		laser_path.append(next_position)
		laser.points = laser_path
		laser_hitbox.position = next_position



func _on_laser_hitbox_area_entered(_area: Area2D) -> void:
	var next_position: Vector2 = laser_path[-1] + laser_hitbox.position.normalized()
	laser_path.append(next_position)
	laser.points = laser_path
	laser_hitbox.position = next_position
	moving = false
