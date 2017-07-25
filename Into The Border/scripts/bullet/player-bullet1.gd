extends Area2D

var speed = 450
var direction = Vector2(0, 0)
var b_range = 1000
var distance_covered = 0
var light_damage = 1
var heavy_damage = 3
onready var anim = get_node("anim")

func _ready():
	add_to_group(global.P_BULLET_GROUP)
	set_process(true)
	pass

func _process(delta):
	# update position
	set_pos(get_pos() + direction * speed * delta)
	distance_covered += speed * delta
	if distance_covered >= b_range:
		queue_free()

func CancelMovement():
	speed = 0

func _on_fastbullet_area_enter( area ):
	if area.is_in_group(global.ENEMY_GROUP):
		if area.has_method("TakeDamage"):
			area.get_node("../").TakeDamage(light_damage)
	if area.is_in_group(global.CONSTRAINT_GROUP) || area.is_in_group(global.ENEMY_GROUP):
		anim.play("destruct")

func _on_heavybullet_area_enter( area ):
	if area.is_in_group(global.ENEMY_GROUP):
		if area.has_method("TakeDamage"):
			area.get_node("../").TakeDamage(heavy_damage)
	if area.is_in_group(global.CONSTRAINT_GROUP) || area.is_in_group(global.ENEMY_GROUP):
		anim.play("destruct")
