extends Area2D

@export var timeline: DialogicTimeline


func _input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("interact")
		and Dialogic.current_timeline == null
		and has_overlapping_bodies()
	):
		Dialogic.start(timeline)
