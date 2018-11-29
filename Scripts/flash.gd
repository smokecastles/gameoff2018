extends Sprite


func _ready():
	get_node("flash_animation").play("fade_out")
	yield(get_node("flash_animation"), "animation_finished")
	queue_free()
	pass

