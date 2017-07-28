extends CanvasLayer

var offset = 4
var heart_width = 32
var position = Vector2(offset, offset)
var variation = Vector2(2*offset + heart_width, 0)
var heart = preload("res://nodes/ui/heart.tscn")
onready var player = get_node("../").get_node("player")

func _ready():
	for i in range(player.hp):
		AddHeart()

func AddHeart():
	var new = heart.instance()
	new.set_pos(position)
	position += variation
	add_child(new)

func RemoveHeart():
	var removal = get_children()[get_children().size()-1]
	removal.queue_free()
	position -= variation