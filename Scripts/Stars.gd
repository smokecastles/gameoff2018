extends Sprite

export var velocity = Vector2()
export var loop = true
onready var size = texture.get_size()
onready var controller = get_node("/root/space_shooter")

func _ready():
	set_process(true)
	size.x = size.x * scale.x
	size.y = size.y * scale.y
	pass
	
func _process(delta):
	if (Controller.playing == false):
		return
	translate(velocity * delta)
	
	if(loop):
		if position.y >= (get_viewport().get_visible_rect().size.y + size.y/2):
			position = Vector2(position.x, -2694)
	pass
