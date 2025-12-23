extends CharacterBody2D

var time_elapsed := 0.0


var speed = 0.0

const max_speed := 10000
const acceleration := 100
const friction := 1000.0

var opposite_direction = null



func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction.length() > 0:
		time_elapsed += delta
		speed = clamp(time_elapsed * acceleration, 0, max_speed)
		velocity = input_direction * speed
	else:
		time_elapsed = 0.0
		velocity = velocity.move_toward( Vector2.ZERO, friction * delta)
	if Input.is_action_pressed("stop"):
		speed = 0
		velocity = Vector2.ZERO
	if Input.is_action_just_pressed("crossover"):
		velocity = -velocity.normalized() * 100
			
	move_and_slide()
