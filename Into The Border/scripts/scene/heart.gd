extends Area2D

func _ready():
	pass

func _on_heart_area_enter( area ):
	if area.is_in_group(global.PLAYER_GROUP):
		area.get_node("../").Heal(1)
		queue_free()
