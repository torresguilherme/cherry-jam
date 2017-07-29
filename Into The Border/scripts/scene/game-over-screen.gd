extends Control

onready var b1 = get_node("b1")
onready var b2 = get_node("b2")

func _ready():
	b1.set_toggle_mode(true)
	b2.set_toggle_mode(true)
	set_process(true)

func _process(delta):
	if b1.is_pressed():
		global.NextScene(0)
	if b2.is_pressed():
		get_tree().quit()
