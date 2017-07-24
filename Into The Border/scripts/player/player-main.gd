extends RigidBody2D

# stats
var speed = 350
var shot_force = 250
var blink_distance = 200
var hp

#cooldowns
var fast_shot_cooldown = .1
var heavy_shot_cooldown = .5
var last_shot = 0
var blink_cooldown = .5
var last_blink = 0

#movement variables
var left = 0
var right = 0
var vert_speed = 0
var in_ground = true
var saved_speed = 0
var disable = false

#bullets
var fast_bullet = preload("res://nodes/bullet/fast-bullet.tscn")
var heavy_bullet
var fbi
var hbi

#onready loads
onready var level = get_node("../")
onready var anim = get_node("anim")
onready var gun = get_node("gun")
onready var shootpoint = gun.get_node("shoot-point")

func _ready():
	add_to_group(global.PLAYER_GROUP)
	set_process(true)

func _process(delta):
	#############################################
	### MOVEMENT
	#############################################
	if Input.is_action_pressed("walk_right") && !disable:
		translate(Vector2(speed * delta, get_linear_velocity().y * delta))
	if Input.is_action_pressed("walk_left") && !disable:
		translate(Vector2(-speed * delta, get_linear_velocity().y * delta))
	
	#############################################
	### BLINK
	#############################################
	if Input.is_action_pressed("blink_left") && last_blink <= 0 && !disable:
		anim.play("blink-left")
		last_blink = blink_cooldown
		pass
	elif Input.is_action_pressed("blink_right") && last_blink <= 0 && !disable:
		anim.play("blink-right")
		last_blink = blink_cooldown
		pass
	if last_blink > 0:
		last_blink -= delta
	
	#############################################
	### SHOOTING
	#############################################
	if Input.is_action_pressed("fast_shoot") && !disable:
		if last_shot <= 0:
			fast_shot()
			last_shot = fast_shot_cooldown
	if Input.is_action_pressed("heavy_shoot") && !disable:
		if last_shot <= 0:
			heavy_shot()
			last_shot = heavy_shot_cooldown
	if last_shot > 0:
		last_shot -= delta

func fast_shot():
	#botar a direcao do tiro (unitarizar o vetor da diferenca entre a posicao do mouse e do centro da arma)
	fbi = fast_bullet.instance()
	fbi.set_global_pos(shootpoint.get_global_pos())
	fbi.look_at(get_global_mouse_pos())
	level.add_child(fbi)
	pass

func heavy_shot():
	pass

func Blink(dir):
	set_pos(get_pos() + Vector2(blink_distance * dir, 0))

func SaveSpeed():
	saved_speed = get_linear_velocity()
	set_sleeping(true)
	disable = true

func LoadSpeed():
	set_sleeping(false)
	disable = false
	set_linear_velocity(saved_speed)