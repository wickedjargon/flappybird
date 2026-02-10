extends Node2D

enum State { WAITING, PLAYING, DEAD }

const PIPE_SCENE := preload("res://scenes/pipe.tscn")
const PIPE_SPAWN_X := 350.0
const PIPE_GAP := 120.0
const PIPE_INTERVAL := 1.6
const GAP_Y_MIN := 120.0
const GAP_Y_MAX := 340.0

var state: State = State.WAITING
var score := 0
var pipe_timer := 0.0

@onready var bird: CharacterBody2D = $Bird
@onready var ground: StaticBody2D = $Ground
@onready var score_label: Label = $UI/ScoreLabel
@onready var message_label: Label = $UI/MessageLabel
@onready var pipes_container: Node2D = $Pipes
@onready var background: ColorRect = $Background

func _ready() -> void:
	_reset()

func _reset() -> void:
	state = State.WAITING
	score = 0
	pipe_timer = 0.0
	score_label.text = "0"
	message_label.text = "Tap to Start"
	message_label.visible = true
	bird.position = Vector2(72, 256)
	bird.rotation = 0
	bird.velocity = Vector2.ZERO
	bird.stop()
	ground.active = true
	
	# Clear existing pipes
	for pipe in pipes_container.get_children():
		pipe.queue_free()

func _process(delta: float) -> void:
	match state:
		State.WAITING:
			if Input.is_action_just_pressed("flap"):
				_start_game()
		State.PLAYING:
			pipe_timer += delta
			if pipe_timer >= PIPE_INTERVAL:
				pipe_timer = 0.0
				_spawn_pipe()
		State.DEAD:
			if Input.is_action_just_pressed("flap"):
				_reset()

func _start_game() -> void:
	state = State.PLAYING
	message_label.visible = false
	bird.start()
	bird.velocity.y = bird.FLAP_VELOCITY
	pipe_timer = PIPE_INTERVAL * 0.6

func _spawn_pipe() -> void:
	var pipe := PIPE_SCENE.instantiate()
	var gap_y := randf_range(GAP_Y_MIN, GAP_Y_MAX)
	pipe.position = Vector2(PIPE_SPAWN_X, gap_y)
	pipe.scored.connect(_on_pipe_scored)
	pipes_container.add_child(pipe)

func _on_pipe_scored() -> void:
	if state == State.PLAYING:
		score += 1
		score_label.text = str(score)

func _on_bird_died() -> void:
	if state != State.DEAD:
		state = State.DEAD
		ground.active = false
		# Stop all pipes
		for pipe in pipes_container.get_children():
			pipe.active = false
		message_label.text = "Game Over
Tap to Restart"
		message_label.visible = true
