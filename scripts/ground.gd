extends StaticBody2D

const SPEED := 120.0
const TILE_WIDTH := 288.0
const GROUND_HEIGHT := 56.0
const GRASS_HEIGHT := 8.0

var active := true
var scroll_offset := 0.0

func _process(delta: float) -> void:
	if not active:
		return
	scroll_offset = fmod(scroll_offset + SPEED * delta, TILE_WIDTH)
	queue_redraw()

func _draw() -> void:
	var ground_color := Color(0.83, 0.69, 0.35, 1)
	var grass_color := Color(0.33, 0.72, 0.19, 1)
	var half_h: float = GROUND_HEIGHT / 2.0

	# Draw 4 tiles to guarantee full screen coverage at any scroll position
	for i in range(-1, 3):
		var x: float = i * TILE_WIDTH - scroll_offset - 144.0
		draw_rect(Rect2(x, -half_h, TILE_WIDTH, GROUND_HEIGHT), ground_color)
		draw_rect(Rect2(x, -half_h, TILE_WIDTH, GRASS_HEIGHT), grass_color)
