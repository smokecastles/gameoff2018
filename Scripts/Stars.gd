extends Sprite

export var velocity = Vector2()
onready var size = texture.get_size()

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	translate(velocity * delta)
	
	if position.y >= (get_viewport().get_visible_rect().size.y + size.y):
		position = Vector2(position.x, -672.193)
	pass
