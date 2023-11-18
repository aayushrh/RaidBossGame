extends PlayerSuper
class_name Healer

@onready var Lazer = preload("res://Players/laser.tscn")
@onready var HealBall = preload("res://Players/healBall.tscn")

var state = RUN 
@export var healCooldown = 5
@export var barrierCooldown = 20
@export var buffAuraCooldown = 10
@export var laserBeamCooldown = 120
var canHeal = true
var canBarrier = true
var canBuff = true
var canLaser = true


enum{
	RUN,
	ATTACK,
	ATTACKING
}

func test(w:float):
	var newthing = Lazer.instantiate()
	newthing.global_position = Vector2(-62,0)
	var disp = global_position.direction_to(user.global_position)
	newthing.target_position = Vector2(0,-1000) 
	newthing.width = w
	add_child(newthing)

func mag(v):
	return sqrt(pow(v.x, 2) + pow(v.y, 2))

func _process(delta):
	if state == RUN:
		movement()
	if(canHeal):
		Heal()
	elif(canBuff):
		BuffAura()
	elif(canBarrier):
		Barrier()
	elif(canLaser):
		Laser()

func _on_hurtbox_area_entered(area):
	posAway = area.global_position

func _on_hurtbox_area_exited(area):
	posAway = Vector2.ZERO

func _on_hurtbox_body_entered(body):
	if shield == null or body.dmg < 0:
		health -= body.dmg
	else:
		health -= body.dmg/2
	if body.dmg <= 0:
		body.queue_free()
	if health <= 0:
		queue_free()

func _on_buffbox_area_entered(area):
	add_buff(area.buff)

func Heal():
	canHeal = false
	var healBall = HealBall.instantiate()
	healBall.maker = self
	healBall.global_position = global_position
	get_tree().current_scene.add_child(healBall)
	$Heal/CooldownHealTimer.start(healCooldown)

func Barrier():
	canBarrier = false
	$Barrier/CooldownBarrierTimer.start(barrierCooldown)
	$BuffAuraCollision._shield_buff()
	$AnimationPlayer.play("ShieldAura")

func Laser():
	canLaser = false
	$Laser/CooldownLaserTimer.start(laserBeamCooldown)
	state = ATTACKING
	test(2.5)
	test(1)

func BuffAura():
	canBuff = false
	$BuffAura/CooldownBuffAuraTimer.start(buffAuraCooldown)
	$BuffAuraCollision._reroll_buff()
	$AnimationPlayer.play("BuffAura")

func _on_cooldown_heal_timer_timeout():
	canHeal = true

func _on_cooldown_barrier_timer_timeout():
	canBarrier = true

func _on_cooldown_buff_aura_timer_timeout():
	canBuff = true

func _on_cooldown_laser_timer_timeout():
	canLaser = true
	
