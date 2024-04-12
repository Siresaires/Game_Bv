extends Node2D

# Dictionary to store wall positions
var wall_positions = {}

# Function to precompute wall positions
func compute_wall_positions():
	# Access the Walls tilemap (assuming it is a child node of WallMap)
	var walls_tilemap = get_node("Walls")
	var tile_size = walls_tilemap.cell_size

# Get the used rect of the tilemap
	var used_rect = walls_tilemap.get_used_rect()

	# Iterate through the tilemap and find wall positions
	for cell_pos in used_rect.position + used_rect.size:
		var tile_id = walls_tilemap.get_cellv(cell_pos)
		if tile_id != -1: # Assuming -1 is an empty tile, adjust if needed
			wall_positions[walls_tilemap.world_to_map(cell_pos)] = true
	# Add debug print to check if the wall positions are computed correctly
	print("Wall Positions:", wall_positions)

func _ready():
	# Emit the signal to send the wall_positions dictionary to the Bullet script
	compute_wall_positions()
	#emit_signal("wall_map_ready", wall_positions)
	
	
