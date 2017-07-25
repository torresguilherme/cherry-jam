extends KinematicBody2D

#stats
var speed = 200
var hp = 40

#onready
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")

func _ready():
	set_process(true)

func _process(delta):
	pass

func TakeDamage(value):
	hp -= value
	damage_anim.play("damage")
