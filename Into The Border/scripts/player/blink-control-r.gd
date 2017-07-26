extends RayCast2D

onready var player = get_node("../")

func _ready():
	set_process(true)

func _process(delta):
	if is_colliding():
		var body = get_collider()
		if body:
			if body.is_in_group(global.CONSTRAINT_GROUP):
				player.can_blink_right = false
			else:
				player.can_blink_right = true
	else:
		player.can_blink_right = true