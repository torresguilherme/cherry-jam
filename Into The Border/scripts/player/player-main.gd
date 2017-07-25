extends RigidBody2D

# stats
var speed = 18000
var shot_force = 400
var blink_distance = 200
var hp = 5

#cooldowns
var fast_shot_cooldown = .1
var heavy_shot_cooldown = .5
var last_shot = 0
var blink_cooldown = .5
var last_blink = 0
var invulnerability_time = 1
var invulnerable = 0

#movement variables
var left = 0
var right = 0
var vert_speed = 0
var saved_speed = 0
var disable = false

#animation control
var on_ground = false
enum anima_side {RIGHT, LEFT}
enum anima_mode {IDLE, WALK, AIR}
var cas = anima_side.RIGHT
var cam = anima_mode.IDLE

#bullets
var fast_bullet = preload("res://nodes/bullet/fast-bullet.tscn")
var heavy_bullet = preload("res://nodes/bullet/heavy-bullet.tscn")
var fbi
var hbi
var module
var vector

#onready loads
onready var level = get_node("../")
onready var sprite = get_node("sprite")
onready var anim = get_node("anim")
onready var move_anim = get_node("move-anim")
onready var damage_anim = get_node("damage-anim")
onready var gun = get_node("gun")
onready var hitbox = get_node("hitbox")
onready var shootpoint = gun.get_node("shoot-point")

func _ready():
	add_to_group(global.PLAYER_BODY_GROUP)
	hitbox.add_to_group(global.PLAYER_GROUP)
	set_process(true)

func _process(delta):
	#############################################
	### MOVEMENT
	#############################################
	if Input.is_action_pressed("walk_right") && !disable:
		if on_ground:
			set_linear_velocity(Vector2(speed * delta, 0))
			cam = anima_mode.WALK
		cas = anima_side.RIGHT
	else:
		if cas == anima_side.RIGHT:
			cam = anima_mode.IDLE
	if Input.is_action_pressed("walk_left") && !disable:
		if on_ground:
			set_linear_velocity(Vector2(-speed * delta, 0))
			cam = anima_mode.WALK
		cas = anima_side.LEFT
	else:
		if cas == anima_side.LEFT:
			cam = anima_mode.IDLE
	if !on_ground:
		cam = anima_mode.AIR
	
	if cas == anima_side.RIGHT:
		if cam == anima_mode.IDLE:
			if move_anim.get_current_animation() != "idle-r":
				move_anim.set_current_animation("idle-r")
		elif cam == anima_mode.WALK:
			if move_anim.get_current_animation() != "walk-r":
				move_anim.set_current_animation("walk-r")
		else:
			if move_anim.get_current_animation() != "air-r":
				move_anim.set_current_animation("air-r")
	else:
		if cam == anima_mode.IDLE:
			if move_anim.get_current_animation() != "idle-l":
				move_anim.set_current_animation("idle-l")
		elif cam == anima_mode.WALK:
			if move_anim.get_current_animation() != "walk-l":
				move_anim.set_current_animation("walk-l")
		else:
			if move_anim.get_current_animation() != "air-l":
				move_anim.set_current_animation("air-l")
	
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
	
	if invulnerable > 0:
		invulnerable -= delta

func fast_shot():
	fbi = fast_bullet.instance()
	fbi.set_global_pos(shootpoint.get_global_pos())
	fbi.look_at(get_global_mouse_pos())
	module = sqrt(pow(gun.get_global_pos().x - get_global_mouse_pos().x, 2) + pow(gun.get_global_pos().y - get_global_mouse_pos().y, 2))
	vector = Vector2((gun.get_global_pos().x - get_global_mouse_pos().x)/module, (gun.get_global_pos().y - get_global_mouse_pos().y)/module)
	fbi.direction = -vector
	level.add_child(fbi)

func heavy_shot():
	hbi = heavy_bullet.instance()
	hbi.set_global_pos(shootpoint.get_global_pos())
	hbi.look_at(get_global_mouse_pos())
	module = sqrt(pow(gun.get_global_pos().x - get_global_mouse_pos().x, 2) + pow(gun.get_global_pos().y - get_global_mouse_pos().y, 2))
	vector = Vector2((gun.get_global_pos().x - get_global_mouse_pos().x)/module, (gun.get_global_pos().y - get_global_mouse_pos().y)/module)
	hbi.direction = -vector
	set_applied_force(Vector2(0, 0))
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(get_global_pos(), vector * shot_force)
	level.add_child(hbi)

func Blink(dir):
	set_pos(get_pos() + Vector2(blink_distance * dir, 0))

func SaveSpeed():
	saved_speed = get_linear_velocity()
	hitbox.remove_from_group(global.PLAYER_GROUP)
	set_sleeping(true)
	disable = true

func LoadSpeed():
	hitbox.add_to_group(global.PLAYER_GROUP)
	set_sleeping(false)
	disable = false
	set_linear_velocity(saved_speed)

func TakeDamage(damage):
	if invulnerable <= 0:
		invulnerable = invulnerability_time
		hp -= damage
		if hp > 0:
			damage_anim.play("damage")
			print("dano")
		else:
			#damage_anim.play("death")
			print("ded")