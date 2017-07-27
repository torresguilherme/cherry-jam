extends KinematicBody2D

#stats
var speed = 200
var hp = 20
var shot_cooldown = 1
var shot_cooldown2 = 2
var shot_type = 0
var last_shot = 0
var knife_shot_speeds = [300, 250, 200]

#movement
var attack_max_distance = 550
var attack_min_distance = 400
var flee_distance = 350
var walk_max_distance = 400
var initial_pos
var distance_from_initial_pos = 0

#player localization
onready var player = get_node("../").get_node("../").get_children()[0]
var player_pos = Vector2(0, 0)
var attacking = false
var in_reach = false

#onready
onready var hitbox = get_node("hitbox")
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")
onready var level = get_node("../")
onready var sounds = get_node("sounds")

#bullets
var bullet = preload("res://nodes/bullet/alien-bullet1.tscn")
var knife = preload("res://nodes/bullet/knife.tscn")

var module
var walking_direction = Vector2(1, 0)

func _ready():
	print(player)
	initial_pos = get_global_pos()
	set_process(true)

func _process(delta):
	#############################################
	### STATE CHANGE
	#############################################
	player_pos = player.get_global_pos()
	if get_global_pos().distance_to(player_pos) <= attack_max_distance:
		in_reach = true
	else:
		in_reach = false
	if in_reach:
		var vision = get_world_2d().get_direct_space_state().intersect_ray(get_global_pos(), player_pos, [self, hitbox])
		if !vision.values().empty():
			if vision.values()[1].is_in_group(global.PLAYER_BODY_GROUP):
				attacking = true
			else:
				attacking = false
		else:
			attacking = false
	else:
		attacking = false
	
	#############################################
	### ATTACK
	#############################################
	if attacking:
		module = sqrt(pow(get_global_pos().x - player_pos.x, 2) + pow(get_global_pos().y - player_pos.y, 2))
		walking_direction = Vector2((get_global_pos().x - player_pos.x)/module, (get_global_pos().y - player_pos.y)/module)
		if last_shot <= 0:
			if shot_type < 3:
				Shoot1(walking_direction)
				last_shot = shot_cooldown
				shot_type += 1
			else:
				Shoot2(walking_direction)
				last_shot = shot_cooldown2
				shot_type = 0
	if last_shot > 0:
		last_shot -= delta
	
	#############################################
	### MOVEMENT
	#############################################
	if attacking:
		if get_global_pos().distance_to(player_pos) >= attack_min_distance && distance_from_initial_pos <= walk_max_distance:
			move(Vector2(-walking_direction * speed * delta))
		elif get_global_pos().distance_to(player_pos) <= flee_distance:
			move(Vector2(walking_direction * speed * delta))
	elif distance_from_initial_pos > 0:
		module = sqrt(pow(get_global_pos().x - initial_pos.x, 2) + pow(get_global_pos().y - initial_pos.y, 2))
		walking_direction = Vector2((get_global_pos().x - initial_pos.x)/module, (get_global_pos().y - initial_pos.y)/module)
		move(Vector2(-walking_direction * speed * delta))
	distance_from_initial_pos = get_global_pos().distance_to(initial_pos)
	
	#############################################
	### ANIMATION
	#############################################
	if walking_direction.x > 0:
		if anim.get_current_animation() != "left":
			anim.set_current_animation("left")
	else:
		if anim.get_current_animation() != "right":
			anim.set_current_animation("right")

func Shoot1(direction):
	sounds.play("alien-fire")
	var new = bullet.instance()
	new.direction = -direction
	new.set_global_pos(get_global_pos())
	level.add_child(new)

func Shoot2(direction):
	sounds.play("knife-fire")
	var new = []
	for i in range(knife_shot_speeds.size()):
		new.append(knife.instance())
		new[i].direction = -direction
		new[i].speed = knife_shot_speeds[i]
		new[i].set_global_pos(get_global_pos())
		level.add_child(new[i])

func TakeDamage(value):
	hp -= value
	if hp > 0:
		sounds.play("enemy-hurt")
		damage_anim.play("damage")
	else:
		sounds.play("enemy-death")
		damage_anim.play("death")
