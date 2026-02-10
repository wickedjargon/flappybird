extends CharacterBody2D

signal died

const FLAP_VELOCITY := -300.0
const GRAVITY := 900.0
const MAX_FALL_SPEED := 400.0

var alive := true
var _started := false

func _ready() -> void:
	pass

func start() -> void:
	_started = true
	alive = true
	velocity = Vector2.ZERO

func stop() -> void:
	_started = false
	alive = false

func _physics_process(delta: float) -> void:
	if not _started:
		# Gentle bob animation while waiting
		position.y += sin(Time.get_ticks_msec() * 0.005) * 0.5
		return
	
	if not alive:
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		move_and_slide()
		return
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	
	# Flap
	if Input.is_action_just_pressed("flap"):
		velocity.y = FLAP_VELOCITY
	
	# Rotate based on velocity
	var target_rotation: float = clamp(velocity.y / MAX_FALL_SPEED, -1.0, 1.0) * deg_to_rad(45)
	rotation = lerp(rotation, target_rotation, delta * 10.0)
	
	move_and_slide()
	
	# Check for collisions with pipes or ground
	if get_slide_collision_count() > 0:
		_die()
	
	# Check if fell off screen
	if position.y > 600 or position.y < -50:
		_die()

func _die() -> void:
	if alive:
		alive = false
		died.emit()
