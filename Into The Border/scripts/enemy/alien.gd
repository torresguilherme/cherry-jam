extends KinematicBody2D

#stats
var speed = 200
var hp = 20
var shot_cooldown = 1
var shot_cooldown2 = 2
var shot_type = 0
var last_shot = 0
var attack_max_distance = 550
var attack_min_distance = 400
var flee_distance = 350
var walk_max_distance = 400
var initial_pos
var distance_from_initial_pos = 0

#player localization
onready var player = get_node("../").get_children()[0]
var player_pos = Vector2(0, 0)
var attacking = false
var in_reach = false

#onready
onready var hitbox = get_node("hitbox")
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")

#bullets
var bullet1 = preload("res://nodes/bullet/alien-bullet1.tscn")

var module
var walking_direction

func _ready():
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
	### ATTACK - MOVEMENT
	#############################################
	if attacking:
		module = sqrt(pow(get_global_pos().x - player_pos.x, 2) + pow(get_global_pos().y - player_pos.y, 2))
		walking_direction = Vector2((get_global_pos().x - player_pos.x)/module, (get_global_pos().y - player_pos.y)/module)
	if attacking && distance_from_initial_pos <= walk_max_distance:
		if get_global_pos().distance_to(player_pos) >= attack_min_distance:
			move(Vector2(-walking_direction * speed * delta))
		elif get_global_pos().distance_to(player_pos) <= flee_distance:
			move(Vector2(walking_direction * speed * delta))
	elif distance_from_initial_pos > 0:
		module = sqrt(pow(get_global_pos().x - initial_pos.x, 2) + pow(get_global_pos().y - initial_pos.y, 2))
		walking_direction = Vector2((get_global_pos().x - initial_pos.x)/module, (get_global_pos().y - initial_pos.y)/module)
		move(Vector2(-walking_direction * speed * delta))
	distance_from_initial_pos = get_global_pos().distance_to(initial_pos)
	
	#############################################
	### ATTACK - SHOOTING
	#############################################
	

func TakeDamage(value):
	hp -= value
	if hp > 0:
		damage_anim.play("damage")
	else:
		damage_anim.play("death")
