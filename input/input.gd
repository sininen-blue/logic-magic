extends Node2D

signal collided(collided_with)

enum Direction {UP, DOWN, LEFT, RIGHT}
@export var direction: Direction = Direction.RIGHT
@export var value: int = 0

var laserPath: PackedVector2Array = []

@onready var laser_ray: RayCast2D = $LaserRay
@onready var laser: Line2D = $Laser


func _ready() -> void:
	if direction == Direction.UP:
		laser_ray.target_position = Vector2(0, -1)
	elif direction == Direction.DOWN:
		laser_ray.target_position = Vector2(0, 1)
	elif direction == Direction.LEFT:
		laser_ray.target_position = Vector2(-1, 0)
	elif direction == Direction.RIGHT:
		laser_ray.target_position = Vector2(1, 0)
	laser_ray.target_position = laser_ray.target_position * 16
		
	laserPath.append(Vector2.ZERO)
	laser.points = laserPath



func _on_timer_timeout() -> void:
	if laser_ray.is_colliding():
		var collided_with: Object = laser_ray.get_collider()
		
		var target: String
		if "Output" in collided_with.name:
			target = collided_with.parent.name
		
		collided.emit(self.name, value, target)
		return
	
	var nextPosition = Vector2(laserPath[-1].x + 16, 0)
	laserPath.append(nextPosition)
	laser.points = laserPath
	
	laser_ray.position = nextPosition
