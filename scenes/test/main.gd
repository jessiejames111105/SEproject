extends TileMap

@onready var player = $World/Player
@onready var grid_helper = $World/GridHelper
@onready var plant_container = $World/Plant

var currentSeed = preload("res://scenes/test/varieties/carrot.tscn")
var planted_plants = {}  # Dictionary to track planted positions and plants

func _ready():
	# Connect player signals
	player.connect("plantSeed", _on_player_plant_seed)
	player.connect("harvest", _on_player_harvest)

func _physics_process(delta):
	# Keep your grid helper visualization
	var player_map_coord = local_to_map(player.global_position)
	var player_dir = player.last_input_vector
	var target_coord = player_map_coord + Vector2i(player_dir)
	grid_helper.global_position = player_map_coord * 16

func _on_player_plant_seed():
	var cell_coord = local_to_map(player.global_position)
	var tile = get_cell_tile_data(2, cell_coord)
	
	if tile == null:
		print("No tile here!")
		return
	
	if tile.get_custom_data("Dirt") != null:
		if not planted_plants.has(cell_coord):
			var new_seed = currentSeed.instantiate()
			plant_container.add_child(new_seed)
			new_seed.global_position = map_to_local(cell_coord)
			planted_plants[cell_coord] = new_seed
			print("Planted seed!")
		else:
			print("There's already a plant here!")
	else:
		print("Can only plant on dirt tiles!")

func _on_player_harvest():
	var cell_coord = local_to_map(player.global_position)
	harvest_plant(cell_coord)

func harvest_plant(cell_coord: Vector2i) -> void:
	if planted_plants.has(cell_coord):
		var plant = planted_plants[cell_coord]
		if plant.harvest_ready:
			plant.harvest()
			planted_plants.erase(cell_coord)
			print("Harvested plant!")
		else:
			print("Plant isn't ready to harvest yet!")
	else:
		print("No plant here to harvest")

func is_harvestable(cell_coord: Vector2i) -> bool:
	var plant = planted_plants.get(cell_coord)
	return plant.harvest_ready if plant != null else false
