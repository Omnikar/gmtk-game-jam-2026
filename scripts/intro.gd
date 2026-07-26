extends Node


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)


func _on_dialogic_signal(arg: String) -> void:
	if arg == "finish_intro":
		get_tree().change_scene_to_file("res://scenes/manor.tscn")
