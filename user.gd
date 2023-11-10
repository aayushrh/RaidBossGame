extends CharacterBody2D

@export var ACCELERATION = 40
@export var FRICK = 0.9
var playing = false
var swang = false
var line = false

func _ready():
	$swordpivot/sword/CollisionShape2D.disabled = true
	$swordpivot/sword.position = Vector2(-2, 35)
	$swordpivot/sword.rotation_degrees = -45
	$swordpivot.rotation_degrees = -450
	$Polygon2D.visible = false

func movement(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
	velocity *= FRICK
	move_and_slide()
	
	var disp = get_global_mouse_position() - global_position
	rotation_degrees = atan2(disp.y, disp.x) * 180/PI + 90
	
func playanimation(input,animation):
	if(Input.is_action_just_pressed(input)):
		$AnimationPlayer.play(animation)
		playing = true
		line = true
		velocity = Vector2.ZERO

func _physics_process(delta):
	playanimation("attack","slash")
	playanimation("special","area_sweep")
	
	if(!playing):
		movement(delta)

func _on_animation_player_animation_finished(anim_name):
	playing = false

