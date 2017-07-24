extends RayCast2D

onready var player = get_node("../")

func _ready():
	set_process(true)

func _process(delta):
	if is_colliding():
		var body = get_collider()
		if body.is_in_group(global.GROUND_GROUP):
			player.on_ground = true
		else:
			player.on_ground = false
	else:
		player.on_ground = false
