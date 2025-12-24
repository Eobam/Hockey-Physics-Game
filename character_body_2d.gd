extends CharacterBody2D

@export_range(0.0, 1.0) var impact_response := 0.5

var time_elapsed := 0.0
var speed := 0.0
var opposite_direction := Vector2.ZERO
var collision_strength := 1.0
var bounciness := 0.6

const max_speed := 10000.0
const acceleration := 100.0
const friction := 1000.0

func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")

	if input_direction.length() > 0.0:
		opposite_direction = -input_direction.normalized()
		time_elapsed += delta
		speed = clamp(time_elapsed * acceleration, 0.0, max_speed)
		velocity = input_direction * speed
	else:
		time_elapsed = 0.0
		speed = 0.0
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	if Input.is_action_pressed("stop"):
		speed = 0.0
		time_elapsed = 0.0
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("crossover") and opposite_direction != Vector2.ZERO:
		velocity = opposite_direction * 1000.0

	var pre_move_velocity := velocity
	move_and_slide()
	resolve_collisions(pre_move_velocity)

func resolve_collisions(pre_move_velocity: Vector2) -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var body := collision.get_collider()

		if body is RigidBody2D:
			var normal := collision.get_normal()
			var incoming: Vector2 = body.linear_velocity
			var bounced: Vector2 = incoming.bounce(normal) * bounciness
			var impact_push: Vector2 = -normal * pre_move_velocity.length() * impact_response * collision_strength
			body.linear_velocity = bounced + impact_push
		else:
			velocity -= velocity.project(collision.get_normal())
