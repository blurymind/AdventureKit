tool
extends Position2D

export var minimum_scale := 0.3
export var maximum_scale := 1.0
export var scale_factor := 0.01


func _process(delta):
	var characters := get_tree().get_nodes_in_group("characters")
	for n in characters:
		var ch := n as Node2D
		# update scale according to this node's position
		var distance := ch.position.distance_to(position)
		var scale = lerp(minimum_scale, maximum_scale, distance * scale_factor)
		ch.scale = Vector2(scale, scale)
