extends Area2D

func _ready():
	pass


func _on_objective_area_enter( area ):
	if area.is_in_group(global.PLAYER_GROUP):
		get_node("../").get_node("scene-anim").play("end")
