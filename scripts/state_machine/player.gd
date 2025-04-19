extends CharacterBody2D

var speed = 50
var last_input_vector = Vector2.ZERO
var is_tilling = false
var tilling_timer = 0.0
const TILLING_DURATION = 1.0  # 1 second

func _ready():
	$AnimatedSprite2D.stop()

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	# Only allow movement if not tilling
	if not is_tilling:
		if Input.is_action_pressed("ui_right"):
			input_vector.x += 1
		if Input.is_action_pressed("ui_left"):
			input_vector.x -= 1
		if Input.is_action_pressed("ui_down"):
			input_vector.y += 1
		if Input.is_action_pressed("ui_up"):
			input_vector.y -= 1

		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO

	# Trigger tilling
	if Input.is_action_just_pressed("tilling") and not is_tilling:
		is_tilling = true
		tilling_timer = TILLING_DURATION
		play_tilling_animation()

	# Handle tilling animation duration
	if is_tilling:
		tilling_timer -= delta
		if tilling_timer <= 0.0:
			is_tilling = false

	# Animation handling (only when not tilling)
	if not is_tilling:
		if input_vector != Vector2.ZERO:
			last_input_vector = input_vector

			if input_vector.x != 0:
				$AnimatedSprite2D.play("sidewalk")
				$AnimatedSprite2D.flip_h = input_vector.x < 0
			elif input_vector.y > 0:
				$AnimatedSprite2D.play("downwalk")
			elif input_vector.y < 0:
				$AnimatedSprite2D.play("upwalk")
		else:
			if last_input_vector != Vector2.ZERO:
				if last_input_vector.x != 0:
					$AnimatedSprite2D.play("idle_side")
				elif last_input_vector.y > 0:
					$AnimatedSprite2D.play("idle_front")
				elif last_input_vector.y < 0:
					$AnimatedSprite2D.play("idle_back")
			else:
				$AnimatedSprite2D.play("idle_front")

	move_and_slide()

func play_tilling_animation():
	if last_input_vector.x != 0:
		$AnimatedSprite2D.play("tilling_side")
		$AnimatedSprite2D.flip_h = last_input_vector.x < 0
	elif last_input_vector.y > 0:
		$AnimatedSprite2D.play("tilling_down")
	elif last_input_vector.y < 0:
		$AnimatedSprite2D.play("tilling_up")
	else:
		# Default to front if no direction
		$AnimatedSprite2D.play("tilling_down")
