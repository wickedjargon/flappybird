extends Node2D

signal scored

const SPEED := 120.0

var _scored := false
var active := true

func _process(delta: float) -> void:
	if not active:
		return
	position.x -= SPEED * delta
	if position.x < -60:
		queue_free()

func _on_score_zone_body_entered(body: Node2D) -> void:
	if not _scored and body is CharacterBody2D:
		_scored = true
		scored.emit()
