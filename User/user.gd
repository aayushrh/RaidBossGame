extends CharacterBody2D

@onready var FlyingSlash = preload("res://User/flying_slash.tscn")

@export var ACCELERATION = 80
@export var FRICK = 0.9
@export var health = 100
@export var DASHSPEED = 2500
@export var DASHTIME = 0.025
var playing = false
var swang = false
var line = false
var dmgTick = 0.0
var timer = 0
var dashing = false

func _ready():
	$swordpivot/sword/CollisionShape2D.disabled = true
	$swordpivot/sword.position = Vector2(-2, 35)
	$swordpivot/sword.rotation_degrees = -45
	$swordpivot.rotation_degrees = -450
	$SlashTele.visible = false
	$SwirlTele.visible = false
	$TelegraphSlash/CollisionShape2D.disabled = true

func dash(delta):
	move_and_slide()

func movement(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION/2
	elif input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
	velocity *= FRICK
	move_and_slide()
	
	if Input.is_action_just_pressed("dash"):
		dashing = true
		velocity = input_vector * DASHSPEED
		$DashTimer.start(DASHTIME)
	
	var disp = get_global_mouse_position() - global_position
	rotation_degrees = atan2(disp.y, disp.x) * 180/PI + 90
	
func playanimation(input,animation):
	timer += 1
	if timer >= 1 and dmgTick > 0:
		health -= dmgTick/60
		timer = 0
	if(Input.is_action_just_pressed(input)):
		$AnimationPlayer.play(animation)
		line = true
		velocity = Vector2.ZERO

func _physics_process(delta):
	$CanvasLayer/ProgressBar.value = health
	playanimation("attack","slash")
	playanimation("attackE","swirl")
	
	if(!playing and !dashing):
		movement(delta)
	elif (!playing and dashing):
		dash(delta)

func _startanim():
	playing = true

func flyingSlash():
	var slash = FlyingSlash.instantiate()
	slash.global_position = $Marker2D.global_position
	slash.dir = Vector2(cos(rotation_degrees * PI/180 - PI/2), sin(rotation_degrees * PI/180 - PI/2))
	slash.rotation_degrees = rotation_degrees
	get_tree().current_scene.add_child(slash)

func _on_animation_player_animation_finished(anim_name):
	playing = false

func _on_hurtbox_body_entered(body):
	health -= body.dmg
	print("hit")
	if health <= 0:
		queue_free()

func _on_hurtbox_area_entered(area):
	dmgTick += area.dmg

func _on_hurtbox_area_exited(area):
	dmgTick -= area.dmg

func _on_dash_timer_timeout():
	dashing = false
