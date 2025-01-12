extends CharacterBody2D

var wasHit = false

var mushroom_scene = load("res://abilities/mushroom red.tscn")
var mushroom

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("players"):
		hit()
		
func hit():
	
	if wasHit:
		$AnimationPlayer.play("Againhit")
	
	else:
		$AnimationPlayer.play("hit")
		wasHit = true
		$sprites/normal.visible = false
		$sprites/empty.visible = true
		spawn_mushroom()
		
		
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "firsthit":
		$sprites/Sprite2D.visible = false

func spawn_mushroom():
	mushroom = mushroom_scene.instantiate()
	mushroom.position.y = position.y + 5
	mushroom.position.x = position.x
	print(mushroom.position)
	print(position)
