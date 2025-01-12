extends CharacterBody2D

#goomba script 


const SPEED = 50.0
var alive =  true
var dir = Vector2()
var timer = false

func _physics_process(delta: float) -> void:
	if alive == true:
		decide()
	
		
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if dir.x == 1:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		
		if dir.x != 0:
			velocity.x = dir.x * SPEED
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
	
	
func decide():
	if $"far left".is_colliding() or $"far right".is_colliding():
		chase()
	elif $"wall left".is_colliding() or $"wall right".is_colliding():
		change_dir()
	else:
		if timer == false:
			var rng = RandomNumberGenerator.new()
			rng.randomize() 
			if rng.randf() < 0.5:  
				dir.x = -1
			else:
				dir.x = 1
			timer = true
			$Timer.start()
		
	
	
func change_dir():
	dir.x *= -1 #flip direction
	
func chase():
	if $"far left".is_colliding():
		dir.x = -1
	else:
		dir.x = 1
	

		
func delete() -> void:
	$".".queue_free()


func _on_timer_timeout() -> void:
	timer = false


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.on_hit(1)


func _on_head_body_entered(body: Node2D) -> void:
	#IF HIT HAPPENED TO  HEAD

	if !alive: return 
	alive = false
	$AnimationPlayer.play("dead")
	$"dead timer".start()
	$"100".visible = true
	$AudioStreamPlayer2D.play()
	#makes player bounce after 
	if body.is_in_group("players"):
		body.bounce()
