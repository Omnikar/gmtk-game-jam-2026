extends CharacterBody2D

@export var move_speed: float = 80.0

var facing_direction: String = "down"


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	var can_move = Dialogic.current_timeline == null

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
