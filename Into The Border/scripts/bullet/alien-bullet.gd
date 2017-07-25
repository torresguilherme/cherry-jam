extends Area2D

var speed = 200
var direction = Vector2(0, 0)
var damage = 1

func _ready():
	add_to_group(global.E_BULLET_GROUP)

func _on_alienbullet1_area_enter( area ):
	if area.is_in_group(global.PLAYER_GROUP):
		area.get_node("../").TakeDamage(damage)
	if area.is_in_group(global.PLAYER_GROUP) || area.is_in_group(global.CONSTRAINT_GROUP):
		queue_free()
