extends CharacterBody2D



const SPEED = 70
var alive =  true
var dir = Vector2()
var timer = false

func _ready() -> void:
	dir.x = 1

func _physics_process(delta: float) -> void:
	if alive == true:
		if $"wall left".is_colliding() or $"wall right".is_colliding():
			dir.x *= -1 #flip direction
			
	
	
		
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		
		if dir.x != 0:
			velocity.x = dir.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
	




func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if !alive: return 
	if body.is_in_group("players"):
		alive = false
		
		if body.hp <= 1:
			$"power up".play()
		elif body.hp == 2:
			$"points add".play()
		$"dead timer".start()
		body.abillity(1)
		
		position.y = -100
		$Sprite2D.visible = false


func _on_dead_timer_timeout() -> void:
	queue_free()
