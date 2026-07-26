extends CharacterBody2D

@export var move_speed: float = 80.0

var facing_direction: String = "up"


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	var show_interact_indicator = false
	if Dialogic.current_timeline == null and not Journal.visible:
		for val in Journal.player_can_interact.values():
			show_interact_indicator = val or show_interact_indicator
	$InteractIndicator.visible = show_interact_indicator

	var can_move = Dialogic.current_timeline == null and not Journal.visible

	if can_move:
		var motion = Vector2(
			(
				float(Input.is_action_pressed("walk_right"))
				- float(Input.is_action_pressed("walk_left"))
			),
			float(Input.is_action_pressed("walk_down")) - float(Input.is_action_pressed("walk_up")),
		)

		# might not actually want this, since motion speed isn't a critical gameplay
		# element and the world is going to be grid-organized
		motion = motion.normalized()

		if motion.y < 0:
			facing_direction = "up"
		elif velocity.y > 0:
			facing_direction = "down"
		elif velocity.x < 0:
			facing_direction = "left"
		elif velocity.x > 0:
			facing_direction = "right"

		velocity = move_speed * motion
	else:
		velocity = Vector2.ZERO

	var status: String
	if velocity != Vector2.ZERO:
		status = "walk"
	else:
		status = "stand"

	var animation_name = "%s_%s" % [facing_direction, status]

	$AnimatedSprite2D.play(animation_name)

	move_and_slide()
