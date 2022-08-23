extends Spatial

const TILE_SIZE := 1.0;
const HEX_TILE = preload("res://Scenes/HexTile.tscn");

export (int, 2, 20) var grid_size_x := 6; 
export (int, 2, 20) var grid_size_y := 6; 

func _ready() -> void:
	_generate_grid();

func _generate_grid():
	for i in range(grid_size_x*grid_size_y):
		var tile = HEX_TILE.instance();
		var cx = 3 * (i % grid_size_x) * TILE_SIZE / 2.0 / 1.7;
		var cy = TILE_SIZE * (i % 2 + floor(i / grid_size_x) * 2.0) * sin(PI / 3.0) / 1.7;
		tile.translate(Vector3(cx, 0, cy));
		add_child(tile);
