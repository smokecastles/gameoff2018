extends MarginContainer

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_exit"):
		Controller.goto_scene("res://MainMenu.tscn")