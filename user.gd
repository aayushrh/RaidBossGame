extends CharacterBody2D

@export var ACCELERATION = 40
@export var FRICK = 0.9
var playing = false
var swang = false

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

func _physics_process(delta):
	if(!swang):
		playanimation("attack","swing")
		playanimation("special","area_sweep")
	else:
		playanimation("ui_select","reverse_swing")
	
	if(!playing):
		movement(delta)
	
	

func _on_animation_player_animation_finished(anim_name):
	swang = anim_name == "swing"
	playing = false
