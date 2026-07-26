extends Node2D

var downstairs_pos: Vector2
var upstairs_pos: Vector2


func _ready() -> void:
	downstairs_pos = $Downstairs.transform.origin
	upstairs_pos = $Upstairs.transform.origin

	show_downstairs()
	hide_upstairs()


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
