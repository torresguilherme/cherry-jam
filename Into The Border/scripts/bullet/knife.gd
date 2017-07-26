extends Area2D

var speed = 200
var direction = Vector2(0, 0)
var damage = 1
var disable = false
var max_range = 1000
var distance_covered = 0
onready var anim = get_node("anim")
onready var sounds = get_node("sounds")

func _ready():
	add_to_group(global.E_BULLET_GROUP)
	look_at(get_global_pos() + direction)
	set_process(true)

func _process(delta):
	set_global_pos(get_global_pos() + Vector2(direction * speed * delta))
	if distance_covered > max_range && !disable:
		anim.play("destruct")

func _on_knife_area_enter( area ):
	if !disable:
		if area.is_in_group(global.PLAYER_GROUP):
			area.get_node("../").TakeDamage(damage)
			anim.play("damage")
		elif area.is_in_group(global.CONSTRAINT_GROUP):
			sounds.play("knife-destruct")
			anim.play("destruct")

func Deactivate():
	speed = 0
	disable = true