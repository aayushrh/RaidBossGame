extends CharacterBody2D
class_name PlayerSuper

@onready var Shield = preload("res://Players/shield.tscn")

@export var ACCELERATION = 40
@export var FRICK = 0.9
@export var circleDistance = 200
@export var health = 10
@export var user : Node2D
var closeToPlayer = false
var posAway = Vector2.ZERO
var buffs = []
var shield = null

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

func is_shield(buff:Buff):
	return buff.statbuff == "shield"

func add_buff(buff:Buff):
	var shieldIn = buffs.any(is_shield)
	if (!(shieldIn && buff.statbuff == "shield")):
		buffs.append(buff)
		do_buff(buff,true)

func do_buff(buff:Buff, multi:bool):
	var temp = 1.0
	if(multi):
		temp*=buff.buffamount
	else:
		temp/=buff.buffamount
	match buff.statbuff:
		"speed":
			ACCELERATION*=temp
		"damage":
			print("One of the players was supposed to get a damage buff")
		"defense":
			print("One of the players was supposed to get a defense buff")
		"shield":
			if temp == 2:
				var tempsh = Shield.instantiate()
				#tempsh.global_position = global_position
				add_child(tempsh)
				shield = tempsh
			else:
				shield.queue_free()
				shield = null

func _physics_process(delta):
	#if buffs.size() <= 2:
	#	add_buff(Buff.new("speed",2,10))
	var e = 0
	for i in range(0, buffs.size()):
		buffs[i-e].timer-=delta
		if(buffs[i-e].timer<=0):
			do_buff(buffs[i-e],false)
			buffs.remove_at(i-e)
			e+=1
