extends Sprite

export var velocity = Vector2()
onready var size = texture.get_size()
onready var controller = get_node("/root/space_shooter")

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	if (controller.playing == false):
		return
	translate(velocity * delta)
	
#	if position.y >= (get_viewport().get_visible_rect().size.y + size.y):
#		position = Vector2(position.x, -672.193)
	pass
