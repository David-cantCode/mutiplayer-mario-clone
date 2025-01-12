extends Node

var num_players
var dead_players
var counter

var playing = false


func _process(delta: float) -> void:
	if playing:
		for x in Global.players:
			if x.dead == true:
				dead_players



func player_add():
	for x in Global.players:
		pass
