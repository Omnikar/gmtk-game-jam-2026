extends Area2D

@export var timeline: DialogicTimeline
@export var reusable: bool = false

var used = false


func _input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("interact")
		and Dialogic.current_timeline == null
		and has_overlapping_bodies()
		and (reusable or not used)
	):
		used = true
		Dialogic.start(timeline)


func _physics_process(_delta: float) -> void:
	Journal.player_can_interact[get_instance_id()] = (
		has_overlapping_bodies() and (reusable or not used)
	)
