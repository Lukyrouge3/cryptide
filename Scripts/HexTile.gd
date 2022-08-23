extends Spatial

signal TileMouseEnter(tile)
signal TileMouseExit(tile)

const OUTLINE_MATERIAL = preload("res://Materials/outline.tres");
const HEIGHT = 0.25;

var albedo = null;
var material = null;

func _ready():
	material = get_node("unit_hex/mergedBlocks(Clone)").material_override;
	albedo = material.albedo_color;

func _on_StaticBody_mouse_exited():
	emit_signal("TileMouseExit", self);

	material.albedo_color = albedo;

	translate(Vector3(0, -HEIGHT, 0));

func _on_StaticBody_mouse_entered():
	emit_signal("TileMouseEnter", self);

	material.albedo_color = Color(albedo.r + 0.1, albedo.g + 0.1, albedo.b + 0.1);

	translate(Vector3(0, HEIGHT, 0));

