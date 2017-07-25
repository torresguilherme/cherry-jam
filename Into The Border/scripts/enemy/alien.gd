extends KinematicBody2D

#stats
var speed = 200
var hp = 40
var shot_cooldown = 1
var last_shot = 0
var attack_max_distance = 600
var attack_min_distance = 400

#player localization
onready var player = get_node("../").get_children()[0]
var player_pos = Vector2(0, 0)
var attacking = false
var in_reach = false

#onready
onready var hitbox = get_node("hitbox")
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")

func _ready():
	set_process(true)

func _process(delta):
	#############################################
	### STATE CHANGE
	#############################################
	player_pos = player.get_global_position()
	if get_global_pos().distance_to(player_pos) <= attack_max_distance:
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
	

func TakeDamage(value):
	hp -= value
	damage_anim.play("damage")
