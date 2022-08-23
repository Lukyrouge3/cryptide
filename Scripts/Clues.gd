extends Node

# We have to decide the clues structure
# What I had in mind was to have an eval function which returns the matching squares
# In order to do so we have to implement things like biome filter, territories, structures and so on.
# To do so we have to navigate trhough the tilemap but the indexes are not linear.


func _getTileIndex(x,y):
	return x + y * 12;

func _getTile(tiles, x, y):
	# We have to convert x, y to index
	var index = _getTileIndex(x,y);
	if index >= 0 && index < tiles.length:
		return tiles[index];
	return null;

func _getNeighbours(tiles, x, y, radius=1):
	var neighbours = [];
	for i in range(-radius, radius+1):
		for j in range(-radius, radius+1):
			if i == 0 && j == 0:
				continue;

			var nx = x + i;
			var ny = y + j;
			if nx < 0 || nx > 11 || ny < 0 || ny > 11:
				continue;

			neighbours.push(_getTile(tiles, nx, ny));
	return neighbours;

func _ready():
	pass # Replace with function body.

