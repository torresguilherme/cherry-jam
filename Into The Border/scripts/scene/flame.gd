extends Area2D

func _ready():
	pass

func _on_flame_area_enter( area ):
	if area.is_in_group(global.PLAYER_GROUP):
		area.get_node("../").TakeDamage(1)
