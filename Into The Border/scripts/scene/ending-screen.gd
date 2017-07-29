extends Control

func _ready():
	set_process(true)
	pass

func _process(delta):
	if Input.is_action_pressed("ui_select"):
		global.NextScene()