extends Spatial

export (int, 0, 5) var partIndex = 0;

const HEX_TILE = preload("res://Scenes/HexTile.tscn");

const BIOME_MATERIALS = [
	preload("res://Materials/Forest.tres"),
	preload("res://Materials/Desert.tres"),
	preload("res://Materials/Swamp.tres"),
	preload("res://Materials/Lake.tres"),
	preload("res://Materials/Mountain.tres")
]

const PARTS_LAYOUT = [
	[
		0, 1, 1, 1, 2, 2,
		0, 0, 1, 3, 2, 2,
		0, 0, 3, 3, 3, 3
	],
	[
		1, 4, 4, 4, 4, 2,
		1, 1, 1, 0, 2, 2,
		0, 0, 0, 0, 0, 2
	],
	[
		2, 2, 0, 0, 0, 3,
		2, 2, 0, 4, 3, 3,
		4, 4, 4, 4, 3, 3
	],
	[
		0, 0, 0, 1, 1, 1,
		3, 3, 3, 4, 1, 1,
		4, 4, 4, 4, 1, 1
	],
	[
		3, 3, 3, 3, 1, 1,
		4, 4, 3, 1, 1, 2,
		4, 4, 4, 2, 2, 2
	],
	[
		0, 3, 3, 3, 3, 4,
		0, 0, 2, 2, 4, 4,
		0, 2, 2, 2, 1, 1
	]
];

const PART_BEAR_TERRITORY = [
	[15, 16, 17],
	[],
	[],
	[],
	[0, 1, 6],
	[0, 6]
];

const PART_PUMA_TERRITORY = [
	[],
	[0, 1, 2],
	[5, 10, 11],
	[11, 17],
	[],
	[]
]

const PART_WIDTH = 6;
const TILE_RADIUS = 0.861;

var tiles = [];
var hoveredTile = null;
var orderedTiles = [];

func _ready():
	randomize();
	var indexes = [0, 1, 2, 3, 4, 5];
	#indexes.shuffle();
	for i in range(6):
		_spawnPart(indexes[i], i%2*0.861*6, floor(i/2.0)*3);
	
	for i in range(3):
		for j in range(3):
			for k in range(6):
				var t = tiles[i*36+j*6+k];
				orderedTiles.append(t);
			for k in range(6):
				var t = tiles[i*36+j*6+k+18];
				orderedTiles.append(t);

func _spawnPart(index, x, y):
	var part = PARTS_LAYOUT[index];
	for i in range(len(part)):
		var tile = HEX_TILE.instance();
		var cx = (i%6) * TILE_RADIUS + x;
		var cy = 0.5 * (i % 2) + floor(i/6.0) + y;
		tile.translate(Vector3(cx, 0, cy));
		tile.get_node("unit_hex/mergedBlocks(Clone)").material_override = BIOME_MATERIALS[part[i]].duplicate();

		if PART_PUMA_TERRITORY[index].find(i) != -1:
			tile.get_node("PumaSprite").visible = true;
	
		if PART_BEAR_TERRITORY[index].find(i) != -1:
			tile.get_node("BearSprite").visible = true;

		#tile.biome = part[i];
		#tile.bear = PART_BEAR_TERRITORY[index].find(i) != -1;
		#tile.puma = PART_PUMA_TERRITORY[index].find(i) != -1;

		tile.connect("TileMouseEnter", self, "_onTileMouseEnter");
		tile.connect("TileMouseExit", self, "_onTileMouseExit");


		tiles.append(tile);
		add_child(tile);


func _onTileMouseEnter(tile: Node):
	hoveredTile = orderedTiles.find(tile);

func _onTileMouseExit(_tile: Node):
	hoveredTile = null;

func _input(event):
	if event is InputEventMouseButton:
		print("Mouse clicked at", event.position);
		if hoveredTile != null:
			print("Clicked tile is", hoveredTile);
