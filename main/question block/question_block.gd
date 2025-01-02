extends CharacterBody2D

var wasHit = false


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("players"):
		hit()
		
func hit():
	
	if wasHit:
		$AnimationPlayer.play("hit")
	
	else:
		$AnimationPlayer.play("firsthit")
		wasHit = true
		$sprites/normal.visible = false
		$sprites/empty.visible = true
		Global.get_coin(1)
		
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "firsthit":
		$sprites/Sprite2D.visible = false
