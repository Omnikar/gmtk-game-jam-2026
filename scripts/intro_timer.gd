extends Timer


func _on_timeout() -> void:
	Dialogic.start("intro")
