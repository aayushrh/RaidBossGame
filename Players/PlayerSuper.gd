extends CharacterBody2D
class_name PlayerSuper

@export var ACCELERATION = 40
@export var FRICK = 0.9
@export var circleDistance = 200
@export var health = 10
@export var user : Node2D
var closeToPlayer = false
var posAway = Vector2.ZERO

func mag(v):
	return sqrt(pow(v.x, 2) + pow(v.y, 2))

func movement():
	var dir = Vector2.ZERO
	if posAway == Vector2.ZERO:
		dir = ((user.global_position) - global_position).normalized()
		var toUser = ((user.global_position) - global_position)
		if mag(toUser) <= circleDistance and !closeToPlayer:
			var angle = atan2(dir.y, dir.x) + PI/2
			dir = Vector2(cos(angle), sin(angle))
	else:
		dir = (global_position - posAway).normalized()
		var angle = atan2(dir.y, dir.x)
		dir = Vector2(cos(angle + PI/2) , sin(angle + PI/2))
	
	velocity += dir * ACCELERATION
	velocity *= FRICK
	move_and_slide()
	
	var disp = global_position - user.global_position
	rotation_degrees = atan2(disp.y, disp.x) * 180/PI - 90
