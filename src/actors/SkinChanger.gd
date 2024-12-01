extends Node
class_name SkinChanger

@export var model: Node3D = null

func set_skin_texture(path: String):
	var material := StandardMaterial3D.new()
	material.set('albedo_texture', load(path))
	material.set('texture_filter', 0) # Nearest neighbour
	material.duplicate(true)
	_apply_texture(model, material)

func _apply_texture(base: Node, material: Material):
	for child in base.get_children():
		_apply_texture(child, material)
		if child is MeshInstance3D:
			# The mesh is shared with all instances of a player.
			# If we change the material on it, it will be changed for all players.
			# A/K/A duplicate mesh, so the new mesh is not referenced by others anymore.
			(child as MeshInstance3D).mesh = (child as MeshInstance3D).mesh.duplicate()
			(child as MeshInstance3D).mesh.surface_set_material(0, material)
