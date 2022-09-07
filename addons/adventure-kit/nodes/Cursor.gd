tool
extends AnimatedSprite

export var create_hotspots : bool setget _create_hotspots
var hotspots := {}

func get_anim_frame(id:int) -> Texture:
	return frames.get_frame(animation, id)

func get_hotspot() -> Vector2:
	if animation in hotspots:
		return hotspots[animation]
	
	return Vector2(0, 0)

func _create_hotspots(value:bool):
	for anim in frames.get_animation_names():
		var pos2D = Position2D.new()
		pos2D.name = anim
		add_child(pos2D)
		pos2D.owner = get_tree().edited_scene_root

func _ready():
	set_process(false)
	hide() # this node should be always hidden

	for ch in get_children():
		if ch is Position2D:
			var abs_pos = ch.position
			abs_pos.x = abs(abs_pos.x)
			abs_pos.y = abs(abs_pos.y) 
			hotspots[ch.name] = abs_pos

	set_process(true)
	update_cursor()
	play(animation)

func update_cursor():
	Input.set_custom_mouse_cursor(
		get_anim_frame(frame),
		Input.CURSOR_ARROW,
		get_hotspot()
	)

func _process(delta):
	update_cursor()
