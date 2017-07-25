extends Area2D

func _ready():
	add_to_group(global.ENEMY_GROUP)

func Deactivate():
	remove_from_group(global.ENEMY_GROUP)