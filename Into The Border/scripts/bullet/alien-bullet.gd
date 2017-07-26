extends Area2D

var speed = 200
var direction = Vector2(0, 0)
var damage = 1
var max_range = 1000
var distance_covered = 0
var disable = false
onready var anim = get_node("anim")

func _ready():
	add_to_group(global.E_BULLET_GROUP)
	set_process(true)

func _process(delta):
	set_global_pos(get_global_pos() + Vector2(direction * speed * delta))
	distance_covered += speed * delta
	if distance_covered > max_range:
		disable = true
		anim.play("destruct")

func _on_alienbullet1_area_enter( area ):
	if !disable:
		if area.is_in_group(global.PLAYER_GROUP):
			area.get_node("../").TakeDamage(damage)
		if area.is_in_group(global.PLAYER_GROUP) || area.is_in_group(global.CONSTRAINT_GROUP):
			disable = true
			anim.play("destruct")

func Deactivate():
	speed = 0
	disable = true