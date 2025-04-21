extends Node2D
class_name Plant

@export var amount: int = 2
@export var growth_time: float = 5.0  # Time to become harvestable
@export var harvest_ready: bool = false

var growth_stage: int = 0

func _ready():
	$Timer.wait_time = growth_time
	$Timer.start()
	update_appearance()

func _on_timer_timeout():
	if not harvest_ready:
		growth_stage += 1
		update_appearance()
		if growth_stage >= 2:  # Assuming 3 stages (0, 1, 2)
			harvest_ready = true
			print("Plant is ready to harvest!")

func update_appearance():
	$AnimationPlayer.play(str(growth_stage))

func harvest() -> void:
	# Add any harvest effects here
	queue_free()
