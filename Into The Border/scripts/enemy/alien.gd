extends KinematicBody2D

#stats
var speed = 200
var hp = 40
var shot_cooldown = 1
var last_shot = 0

#player localization
onready var player = get_node("../").get_children()[0]
var player_pos = Vector2(0, 0)

#onready
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")

func _ready():
	set_process(true)

func _process(delta):
	player_pos = player.get_global_position()

func TakeDamage(value):
	hp -= value
	damage_anim.play("damage")
