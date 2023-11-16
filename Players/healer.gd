extends CharacterBody2D

@onready var Laser = preload("res://Players/laser.tscn")
@onready var Heal = preload("res://Players/heal.tscn")
@export var circleDistance = 300
@export var user : Node2D
@export var ACCELERATION = 40
@export var FRICK = 0.9
@export var health = 10

var state = RUN 
var closeToPlayer = false
var posAway = Vector2.ZERO
@export var maxMP = 1000
@export var MPregen = 10
var MP = maxMP
@export var HealMPCost = 15
@export var LaserMPCost = 500
@export var BarrierMPCost = 105
@export var BuffAuraMPCost = 400
@export var healCooldown = .5
@export var laserCooldown = 100
@export var BarrierCooldown = 10
@export var BuffAuraCooldown = 60


enum{
	RUN,
	ATTACK,
	ATTACKING
}

func test(w):
	#if(Input.is_action_just_pressed("attack")):
	var newthing = Laser.instantiate()
	newthing.global_position = Vector2(-62,0)
	var disp = global_position.direction_to(user.global_position)
	newthing.target_position = Vector2(0,-1000) 
	newthing.width = w
	add_child(newthing)

func mpRegen(delta):
	if(MP<maxMP):
			MP+=delta*MPregen
			if(MP>maxMP):
				MP=maxMP

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

func _physics_process(delta):
	if state == RUN:
		movement()
		laser()

func heal():#nearest things gets healed via green thing express(TM)
	if(MP>=HealMPCost):
		MP-=HealMPCost
		state = ATTACKING
		var heal = Heal.instantiate()
		heal.global_position = global_position
		heal.dir = (user.global_position - global_position).normalized()
		get_tree().current_scene.add_child(heal)
		$Knife/CooldownKnifeTimer.start(healCooldown)

func laser():
	if(MP>=LaserMPCost):
		MP-=LaserMPCost
		state = ATTACKING
		test(2.5)
		test(1)
	
func barrier():
	if(MP>=BarrierMPCost):
		MP-=BarrierMPCost

func buffAura():
	if(MP>=BuffAuraMPCost):
		MP-=BuffAuraMPCost

func _on_hurtbox_area_entered(area):
	posAway = area.global_position

func _on_hurtbox_area_exited(area):
	posAway = Vector2.ZERO

func _on_hurtbox_body_entered(body):
	health -= body.dmg
	if health <= 0:
		queue_free()
