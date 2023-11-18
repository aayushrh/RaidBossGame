extends Area2D

var buffList = ["speed","defense","damage"]
var rng = RandomNumberGenerator.new()
var buff = Buff.new(buffList[rng.randi_range(0,buffList.size()-1)],1.5,10)

func _reroll_buff():
	buff = Buff.new(buffList[rng.randi_range(0,buffList.size()-1)],1.5,10)

