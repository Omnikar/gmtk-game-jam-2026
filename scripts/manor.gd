extends Node2D

var downstairs_pos: Vector2
var upstairs_pos: Vector2


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

	downstairs_pos = $Downstairs.transform.origin
	upstairs_pos = $Upstairs.transform.origin

	show_downstairs()
	hide_upstairs()

	Dialogic.start("detective_introduction")


func show_downstairs() -> void:
	$Downstairs.show()
	$Downstairs.transform.origin = downstairs_pos


func show_upstairs() -> void:
	$Upstairs.show()
	$Upstairs.transform.origin = upstairs_pos


func hide_downstairs() -> void:
	$Downstairs.hide()
	$Downstairs.transform.origin = downstairs_pos
	$Downstairs.transform.origin.x += 1000


func hide_upstairs() -> void:
	$Upstairs.hide()
	$Upstairs.transform.origin = upstairs_pos
	$Upstairs.transform.origin.x += 1000


func _on_downstairs_trigger_body_entered(_body: Node2D) -> void:
	show_downstairs()
	hide_upstairs()


func _on_upstairs_trigger_body_entered(_body: Node2D) -> void:
	hide_downstairs()
	show_upstairs()


func _on_music_finished() -> void:
	$Music.play()


func _on_dialogic_signal(arg: Dictionary) -> void:
	if not arg.has("level_status"):
		return
	var status = arg["level_status"]
	if status == "starting":
		$Music.playing = true
	if status == "completing":
		$Music.playing = false
		$FinalMusic.playing = true
	if status == "complete":
		$Thanks.show()
