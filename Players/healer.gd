extends CharacterBody2D

@onready var Laser = preload("res://Players/laser.tscn")

func test():
	if(Input.is_action_just_pressed("attack")):
		var newthing = Laser.instantiate()
		newthing.global_position = Vector2(-62,0)
		print(global_position)
		print(newthing.global_position)
		var disp = global_position.direction_to(get_global_mouse_position())
		newthing.target_position = Vector2(0,-1000) 
		print(newthing.target_position)
		add_child(newthing)
