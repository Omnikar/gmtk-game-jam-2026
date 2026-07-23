extends CharacterBody2D

@export var move_speed: float = 80.0


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

		velocity = move_speed * motion
	else:
		velocity = Vector2.ZERO

	move_and_slide()
