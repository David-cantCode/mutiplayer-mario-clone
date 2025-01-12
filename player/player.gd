extends CharacterBody2D

const GRAVITY = 700
const JUMP_FORCE = -300
const MAX_HOLD_JUMP_TIME = 1 # Maximum time the jump button can be held for higher jump
const RUN_SPEED = 150
const WALK_SPEED = 50

	
var hp: int = 1
var characters = [1,2,3] #mario luigi idk
var character = 0 #0 = null
var is_jumping = false
var jump_time = 0
var moving = false
var speed = WALK_SPEED
var gravity = 1000
var jump_velocity = -200  # Initial jump velocity
var max_jump_hold_time = 0.6  # Max time player can hold jump to increase height
var jump_boost = -600  # Additional upward force while holding jum
var can_move = false
var ani
var crouched
var sprite
var dead =  false
var player_id: int = -1 
var can_get_hit = true

var lives
var player #P1, P2 P3


@onready var Marioani = $"mario/mario ani"
@onready var Mariosprite = $"mario/big"
@onready var Charmenu = $Charmenu


func _enter_tree() -> void:
	# Set multiplayer authority during _enter_tree
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
	if is_multiplayer_authority():
		show_menu()
	else:
		hide_menu()
	sprite = Mariosprite
	ani = Marioani
	
	
func _process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	animations()
	sprite_control()
	
	
func _physics_process(delta: float) -> void:
	#************************
	# Main physics
	#************************
	
	if not is_multiplayer_authority(): return #if the online id = this scenes id keep going | prevents people who are not this player from using this plahyer
	# Apply gravity

	if can_move == false: return 

	
	if Input.is_action_pressed("crouch"):
		crouched = true
		if hp != 1: $".".position.y -= .8
		$CollisionShape2D.scale.y = 0.5
		
		
		
	elif Input.is_action_just_released("crouch"):
		crouched = false
		if hp != 1:  $".".position.y += .8
		$CollisionShape2D.scale.y = 1
		
	if Input.is_action_pressed("shift"):
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED
	

	
	if not is_on_floor():
		velocity.y += gravity * delta

	# Move left and right
	velocity.x = 0
	if  Input.is_action_pressed("left"):
		velocity.x = -speed
		if sprite: sprite.flip_h = true
		moving = true
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		if sprite: sprite.flip_h = false
		moving = true
	else:
		moving = false

	# Start jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		is_jumping = true
		jump_time = 0
		$AudioStreamPlayer2D.play()

	# Continue jump while holding
	if is_jumping and Input.is_action_pressed("jump"):
		jump_time += delta
		if jump_time < max_jump_hold_time:
			velocity.y += jump_boost * delta

	# Stop jump boost when releasing the button
	if Input.is_action_just_released("jump"):
		is_jumping = false

	# Stop jump boost if max hold time is exceeded
	if jump_time >= max_jump_hold_time:
		is_jumping = false
		
	move_and_slide()
			 
		  
func animations():
	#************************
	#ANIMATIONS
	#************************
	
	if character == 0: return
	
	if is_jumping:
		ani.play("jump")
	elif crouched == true:
		ani.play("crouch")
	elif not is_on_floor():
		ani.play("fall")
	elif speed == WALK_SPEED and moving == true:
		ani.play("walk")
	elif speed == RUN_SPEED and moving == true:
		ani.play("run")
	elif not moving:
		ani.play("idle")
	

	#************************
	#CHARACTER SELECTION STUFF BELOW
	#************************


func sprite_control():
	if character == 1:
		if hp <= 1:
			ani = $mario/babyani
			sprite = $mario/baby
			$mario/baby.visible = true
			$CollisionShape2D.scale.y = 0.5
			$mario/big.visible = false
	
		elif hp == 2:
			$mario/big.visible = true
			sprite = $mario/big
			ani = $"mario/mario ani"
			if !crouched: $CollisionShape2D.scale.y = 1
			$mario/baby.visible = false
			
	if character == 2:
		if hp <= 1:
			ani = $"luigi/baby ani"
			sprite = $luigi/baby
			$luigi/baby.visible = true
			$luigi/big.visible = false
			$CollisionShape2D.scale.y = 0.5
			
		elif hp == 2:
			ani = $"luigi/big ani"
			sprite = $luigi/big
			$luigi/big.visible = true
			if !crouched: $CollisionShape2D.scale.y = 1
			$luigi/baby.visible = false

func show_menu():
	Charmenu.visible = true
	$mario.visible = false
	$luigi.visible = false

func hide_menu():
	Charmenu.visible = false
	
func Chosemario():
		character = 1
		$mario.visible = true
		Charmenu.visible = false
		can_move = true
		sprite_control()
		
func choseluigi() -> void:
		can_move = true
		character = 2
		$luigi.visible = true
		Charmenu.visible = false
		sprite_control()



func set_player_id(id: int) -> void:
	player_id = id

	
func bounce():
	#************************
	#used when kills enemey
	#************************
	velocity.y = -250
	

func on_hit(dmg):
	hp -= dmg
	print(hp)
	if hp == 1:
		$"power down".play()
	if hp < 0:
		dead = true
		

func abillity(type):
	#1 mushroom
	hp = 2
