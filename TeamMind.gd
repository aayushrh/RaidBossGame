extends Node2D

@onready var Player = preload("res://player.tscn")
var atypes = ["Beserker", "Rogue", "Archer"]
var stypes = ["Healer", "Alchemist"]

var rng = RandomNumberGenerator.new()
var attacking = false

enum{
	RUN,
	ATTACK,
	ALLY
}

func _ready():
	var num = rng.randi_range(1, 4)
	for i in range(1.0, num + 1):
		var player = Player.instantiate()
		var num2 = rng.randi_range(1, 4)
		if(num2 < i):
			var num3 = rng.randi_range(0, stypes.size() - 1)
			player.type = stypes[num3]
			player.spec = "s"
		else:
			var num3 = rng.randi_range(0, atypes.size() - 1)
			player.type = atypes[num3]
			player.spec = "a"
		player.global_position = Vector2(1000, 648*(i-1)/num + 648/(num*2))
		player.teamM = self
		add_child(player)

func _process(delta):
	var team = get_children()
	if !attacking and !team[0].tired:
		for j in range(0, chance()):
			var num1 = rng.randi_range(0, team.size() - 1)
			team[num1]._attack()
		for k in range(0, team.size()):
			if (team[k].state != ATTACK):
				team[k].state = ALLY
		attacking = true

func chance():
	var sum = 0
	for i in range(0, get_children().size()):
		sum += pow(2, i)
	var num = rng.randi_range(1, sum)
	if sum == 15:
		if num <= 8:
			return 1
		elif num <= 12:
			return 2
		elif num <= 14:
			return 3
		else:
			return 4
	elif sum == 7:
		if num <= 4:
			return 1
		elif num <= 6:
			return 2
		else:
			return 3
	elif sum == 3:
		if num <= 2:
			return 1
		else:
			return 2
	else:
		return 1

func attackOver():
	for i in get_children():
		i.state = RUN
		attacking = false
