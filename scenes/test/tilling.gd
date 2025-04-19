extends Node2D

# This will store tile positions and how many times they've been hit
var hit_counter = {}

# Reference to your AnimatedSprite2D (make sure to set it in the editor or get via code)
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.visible = false  # Hide until needed
	

func till_tile(tile_pos: Vector2):
	var key = str(tile_pos)
	if !hit_counter.has(key):
		hit_counter[key] = 1
	else:
		hit_counter[key] += 1
	
	if hit_counter[key] >= 3:
		animated_sprite.position = tile_pos * 16  # Adjust if tile size differs
		animated_sprite.visible = true
		animated_sprite.frame = 1  # Tilled dirt frame
		
func is_tile_tilled(tile_pos: Vector2i) -> bool:
	var key = str(tile_pos)
	return hit_counter.has(key) and hit_counter[key] >= 3
