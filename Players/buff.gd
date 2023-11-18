extends Node
class_name Buff
var timer
var statbuff
var buffamount

func _init(buffedStat:String, buffedAmount:float, duration:float):
	timer = duration
	statbuff = buffedStat
	buffamount = buffedAmount



