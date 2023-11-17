extends PlayerSuper

@onready var Laser = preload("res://Players/laser.tscn")

var state = RUN 

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
