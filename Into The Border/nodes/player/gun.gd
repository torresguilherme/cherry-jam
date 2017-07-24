extends Sprite

var target
func _ready():
	set_process(true)

func _process(delta):
	target = get_global_mouse_pos()
	look_at(target)
