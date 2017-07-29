extends Node

# grupos
var PLAYER_GROUP = "player"
var PLAYER_BODY_GROUP = "player-body"
var ENEMY_GROUP = "enemy"
var CONSTRAINT_GROUP = "constraint"
var GROUND_GROUP = "ground"
var E_BULLET_GROUP = "enemy-bullet"
var P_BULLET_GROUP = "player-bullet"

var scenes = []
var current_scene = 0

func _ready():
	scenes.append(load("res://nodes/scene/start-screen.tscn"))
	scenes.append(load("res://nodes/scene/level1.tscn"))
	scenes.append(load("res://nodes/scene/ending-screen.tscn"))
	pass

func NextScene():
	current_scene += 1
	if current_scene == scenes.size():
		current_scene = 0
	get_tree().change_scene_to(scenes[current_scene])
	print(get_tree().get_current_scene())