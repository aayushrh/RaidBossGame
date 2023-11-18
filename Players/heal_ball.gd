extends CharacterBody2D

@export var speed = 500
@export var dmg = -2.0
var player = null

func _process(delta):
	if(player != null):
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

func _on_player_finder_body_entered(body):
	if body is Node2D and !(body is Healer):
		player = body
