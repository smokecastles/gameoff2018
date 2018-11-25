extends Sprite

func _ready():
	var player = get_node("flare_animation")
	player.play("fade_out")
	yield(player, "animation_finished")
	queue_free()
	pass

