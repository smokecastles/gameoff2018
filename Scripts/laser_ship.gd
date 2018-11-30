extends "res://scripts/laser.gd"

onready var camera = get_node("/root/space_shooter/camera_shake")

func _ready():
	connect("area_entered", self, "_on_area_enter")
	pass

func _on_area_enter(other):
	if other.is_in_group("enemy"):
		other.armor -= 1
		create_flare()
		camera.shake(1, 0.13)       
		queue_free()
	pass
