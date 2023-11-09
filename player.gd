extends CharacterBody2D

const ACCELERATION = 4000
const MAX_SPEED = 40000;
const FRICK = .9
var playing = false
var swang = false

func movement(acc, maxsped, fric, delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * maxsped*delta, acc)
	else:
		velocity =velocity*fric
	move_and_slide()
	
func playanimation(input,animation):
	if(Input.is_action_just_pressed(input)):
		$AnimationPlayer.play(animation)
		playing = true
		

func _physics_process(delta):
	if(!swang):
		playanimation("ui_select","swing")
		playanimation("F","area_sweep")
	else:
		playanimation("ui_select","reverse_swing")
	
	
	if(!playing):
		movement(ACCELERATION,MAX_SPEED,FRICK,delta)
	
	

func _on_animation_player_animation_finished(anim_name):
	swang = anim_name == "swing"
	playing = false
