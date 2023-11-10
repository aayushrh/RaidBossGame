extends CharacterBody2D

@export var type = ""
@export var spec = ""
@export var state = RUN
var teamM = null
var tired = false
enum{
	RUN,
	ATTACK,
	ALLY
}

func _attack():
	state = ATTACK
	$Timer.start(5)

func _on_timer_timeout():
	teamM.attackOver()
	tired = true
	$Timer2.start(3)

func _on_timer_2_timeout():
	tired = false
