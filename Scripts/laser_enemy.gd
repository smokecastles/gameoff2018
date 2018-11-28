extends "res://scripts/laser.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	connect("area_entered", self, "_on_area_enter")
	pass

func _on_area_enter(other):
	if other.is_in_group("ship"):
		other.armor -= 1
		create_flare()
		queue_free()
	pass
