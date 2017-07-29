extends Label

func _ready():
	pass

func Text(value):
	if value == 1:
		set_text("Jegus9's entry for GDN's Cherry Jam")
	elif value == 2:
		set_text("INTO THE BORDER")

func NextScene():
	global.NextScene(1)