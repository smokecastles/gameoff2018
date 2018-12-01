extends Area2D

export var velocity = Vector2()
const scn_flare = preload("res://Scenes/Flare.tscn")
onready var controller = get_node("/root/space_shooter")

func _ready():
	set_process(true)
	create_flare()
	
	yield(get_node("vis_notifier"), "screen_exited")
	queue_free()
	pass
	
func _process(delta):
	translate(velocity * delta)
	pass

func create_flare():
	var flare = scn_flare.instance()
	flare.position = position
	get_tree().get_root().add_child(flare)
	pass