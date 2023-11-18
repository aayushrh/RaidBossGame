extends PlayerSuper

@onready var Knife = preload("res://Players/knife.tscn")

@export var slashCooldown = 2
@export var knifeCooldown = 5
@export var backstabCooldown = 10
@export var silentClawCooldown = 20
@export var silentClawRadius = 150
@export var silentClawSpeed = 10
@export var silentClawDuration = 3
var playing = false
var can_backstab = true
var can_knife = true
var can_slash = true
var can_silentClaw = true
var state = RUN
var slashTimer = 0
var rng = RandomNumberGenerator.new()
var line : Node

enum{
	RUN,
	ATTACK,
	ATTACKING,
	SILENTCLAW
}

func _ready():
	$swordpivot/sword/CollisionShape2D.disabled = true
	$swordpivot/sword.position = Vector2(-2, 35)
	$swordpivot/sword.rotation_degrees = -45
	$swordpivot.rotation_degrees = -450
	$Hitbox/CollisionShape2D.shape.radius = silentClawRadius

func mag(v):
	return sqrt(pow(v.x, 2) + pow(v.y, 2))

func attackCheck():
	if can_silentClaw:
		closeToPlayer = true
		var toUser = ((user.global_position) - global_position)
		if mag(toUser) <= 0.5*silentClawRadius:
			silentClaw()
	elif can_backstab:
		backstab()
	elif can_knife:
		knife()
	elif can_slash:
		closeToPlayer = true
		var toUser = ((user.global_position) - global_position)
		if mag(toUser) <= 50:
			slash()
	
func _process(delta):
	if(!playing):
		if state == RUN:
			movement()
			attackCheck()
		elif state == SILENTCLAW:
			slashing()

func _on_animation_player_animation_finished(anim_name):
	playing = false
	state = RUN

"""Attacks"""

func slash():
	can_slash = false
	$AnimationPlayer.play("slash")
	$Slash/CooldownSlashTimer.start(slashCooldown)

func knife():
	can_knife = false
	var knife = Knife.instantiate()
	knife.global_position = global_position
	knife.dir = (user.global_position - global_position).normalized()
	get_tree().current_scene.add_child(knife)
	$Knife/CooldownKnifeTimer.start(knifeCooldown)

func backstab():
	can_backstab = false
	visible = false
	$Backstab/AppearBackstabTimer.start(rng.randf_range(0.5, 1))
	state = ATTACKING

func silentClaw():
	can_silentClaw = false
	visible = false
	$SilentClaw/AppearSilentClawTimer.start(rng.randf_range(0.5, 1))
	state = ATTACKING
	if line == null:
		var linenew = Line2D.new()
		linenew.points = [global_position, global_position, global_position, global_position, global_position]
		get_tree().current_scene.add_child(linenew)
		line = linenew
	else:
		line.points = [global_position, global_position, global_position, global_position, global_position]
	$Hurtbox/CollisionShape2D.disabled = true

func slashing():
	slashTimer += 1
	if slashTimer >= 5:
		slashTimer = 0
		var angle = rng.randf_range(0, 2*(PI))
		var magnitude = rng.randf_range(0, silentClawRadius)
		line.points = [line.points[1], line.points[2], line.points[3], line.points[4], global_position + magnitude * Vector2(cos(angle), sin(angle))]

"""Danger Sense/Damage"""

func _on_hurtbox_area_entered(area):
	posAway = area.global_position

func _on_hurtbox_area_exited(area):
	posAway = Vector2.ZERO

func _on_hurtbox_body_entered(body):
	health -= body.dmg
	print("hit")
	if health <= 0:
		queue_free()

"""Buffs"""

func _on_buffbox_area_entered(area):
	add_buff(area.buff)

"""Slash Attack Timers"""

func _on_cooldown_slash_timer_timeout():
	can_slash = true

"""Knife Throw Attack Timers"""

func _on_cooldown_knife_timer_timeout():
	can_knife = true

"""Backstab Attack Timers"""

func _on_appear_backstab_timer_timeout():
	global_position = user.global_position - 75*Vector2(cos((user.rotation_degrees - 90) * PI/180), sin((user.rotation_degrees-90) * PI/180))
	visible = true
	var disp = get_global_mouse_position() - user.global_position
	rotation_degrees = atan2(disp.y, disp.x) * 180/PI + 90
	$Backstab/AttackBackstabTimer.start(rng.randf_range(0.5, 0.75))
	
func _on_attack_backstab_timer_timeout():
	$AnimationPlayer.play("slash")
	$Backstab/CooldownBackstabTimer.start(backstabCooldown)
	
func _on_cooldown_backstab_timer_timeout():
	can_backstab = true

"""Silent Claw Attack Timers"""

func _on_appear_silent_claw_timer_timeout():
	state = SILENTCLAW
	$Hitbox/CollisionShape2D.disabled = false
	$SilentClaw/AttackSilentClawTimer.start(silentClawDuration)
	print("e")

func _on_attack_silent_claw_timer_timeout():
	state = RUN
	visible = true
	$Hitbox/CollisionShape2D.disabled = true
	line.points = []
	$SilentClaw/CooldownSilentClawTimer.start(silentClawCooldown)
	$Hurtbox/CollisionShape2D.disabled = false

func _on_cooldown_silent_claw_timer_timeout():
	can_silentClaw = true
	

