extends Area2D

signal show_text_box

export(String, MULTILINE) var text = ""

var shown = false

func _on_ShowTextArea2D_body_entered(body):
	if not shown and body.get_name() == "Player":
		emit_signal("show_text_box", text)
		shown = true