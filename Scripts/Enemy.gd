extends Area2D

export var velocity = Vector2()
onready var size = get_node("sprite").texture.get_size()

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	translate(velocity * delta)
	
	if position.y >= get_viewport_rect().size.y + size.y:
		queue_free()
	pass