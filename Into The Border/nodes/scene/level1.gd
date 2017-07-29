extends Node2D

func _ready():
	pass

func NextScene():
	global.NextScene(2)

func GameOver():
	global.NextScene(3)