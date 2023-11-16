extends CharacterBody2D

@export var dir = Vector2.ZERO
@export var speed = 1000
@export var dmg = 1

func _process(delta):
	rotation_degrees = atan2(dir.y, dir.x) * 180/PI + 90
	velocity = dir * speed
	move_and_slide()
