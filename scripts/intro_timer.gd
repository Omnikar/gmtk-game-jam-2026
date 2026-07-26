extends Timer


func _on_timeout() -> void:
	if Dialogic.current_timeline == null:
		Dialogic.start("intro")
