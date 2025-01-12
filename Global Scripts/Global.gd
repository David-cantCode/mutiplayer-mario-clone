extends Node

var oneups = 0
var coins = 99

var players: Array = []


func get_coin(add):
	coins += add
	
	if coins > 100:
		oneups += 1
		coins -= 100
		get_coin(0)
	elif coins == 100:
		oneups += 1
		coins = 0
		get_coin(0)
	else:
		pass
		
	print(oneups)
			
