extends CharacterBody2D

@onready var Laser = preload("res://Players/laser.tscn")

@export var circleDistance = 300
@export var user : Node2D
@export var ACCELERATION = 40
@export var FRICK = 0.9
@export var health = 10

var state = RUN 
var closeToPlayer = false
var posAway = Vector2.ZERO

enum{
	RUN,
	ATTACK,
	ATTACKING
}

func test():
	if(Input.is_action_just_pressed("attack")):
		var newthing = Laser.instantiate()
		newthing.global_position = Vector2(-62,0)
		print(global_position)
		print(newthing.global_position)
		var disp = global_position.direction_to(user.global_position)
		newthing.target_position = Vector2(0,-1000) 
		print(newthing.target_position)
		add_child(newthing)

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
	
	velocity += dir * ACCELERATION
	velocity *= FRICK
	move_and_slide()
	
	var disp = global_position - user.global_position
	rotation_degrees = atan2(disp.y, disp.x) * 180/PI - 90

func _process(delta):
	if state == RUN:
		movement()
		

func _on_hurtbox_area_entered(area):
	posAway = area.global_position

func _on_hurtbox_area_exited(area):
	posAway = Vector2.ZERO

func _on_hurtbox_body_entered(body):
	health -= body.dmg
	if health <= 0:
		queue_free()
