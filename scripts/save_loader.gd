extends Node


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

	# var save_file = FileAccess.open("user://save.json", FileAccess.READ)
	if not FileAccess.file_exists(Journal.save_path):
		start_intro()
	else:
		Dialogic.start("startup")


func _on_dialogic_signal(arg: Dictionary) -> void:
	if arg["should_load_save"]:
		Journal.load_game()
		start_directly()
	else:
		start_intro()


func start_intro() -> void:
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func start_directly() -> void:
	get_tree().change_scene_to_file("res://scenes/manor.tscn")
