extends RigidBody2D

# stats
var speed = 300
var blink_distance = 200
var hp

#cooldowns
var fast_shot_cooldown = .1
var heavy_shot_cooldown = .5
var last_shot = 0
var blink_cooldown = .7
var last_blink = 0

#movement variables
var left
var right
var in_ground = true

#bullets
var fast_bullet
var heavy_bullet

func _ready():
	set_process(true)

func _process(delta):
	#############################################
	### MOVEMENT
	#############################################
	if Input.is_action_pressed("walk_right"):
		left = -1
	if Input.is_action_pressed("walk_left"):
		right = 1
	
	# UPDATE POSITION
	set_global_pos(get_global_pos() + Vector2(1.0, 0.0) * (left + right))
	
	#############################################
	### BLINK
	#############################################
	if Input.is_action_pressed("blink_left"):
		pass
	if Input.is_action_pressed("blink_right"):
		pass
	if last_blink > 0:
		last_blink -= delta
	
	#############################################
	### SHOOTING
	#############################################
	if Input.is_action_pressed("fast_shoot"):
		if last_shot <= 0:
			fast_shot()
			last_shot = fast_shot_cooldown
	if Input.is_action_pressed("heavy_shoot"):
		if last_shot <= 0:
			heavy_shot()
			last_shot = heavy_shot_cooldown
	if last_shot > 0:
		last_shot -= delta

func fast_shot():
	pass

func heavy_shot():
	pass