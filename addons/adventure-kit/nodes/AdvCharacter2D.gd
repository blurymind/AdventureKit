extends KinematicBody2D
class_name AdventureCharacter2D, "res://addons/adventure-kit/icons/walk.svg"

export var speed := 100.0 setget _set_speed, _get_speed
export var input_disabled := false setget _set_input_disabled, _get_input_disabled
onready var _agent := $NavigationAgent2D as NavigationAgent2D

var _velocity := Vector2.ZERO
var walk_ended := true

signal walk(direction, speed)
signal walk_end()

func _set_input_disabled(disabled: bool):
	set_process_input(!disabled)
	_agent.avoidance_enabled = !disabled


func _get_input_disabled() -> bool:
	return !is_processing_input()


# func _input(event):
# 	if not event.is_action_pressed("left_click"):
# 		return

# 	var mouse_pos := get_global_mouse_position()
# 	walk_to(mouse_pos)


func walk_to(location: Vector2):
	_agent.set_target_location(location)


func _set_speed(value: float):
	_agent.max_speed = value


func _get_speed() -> float:
	return _agent.max_speed


func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		var mouse_pos := get_global_mouse_position()
		walk_ended = false
		walk_to(mouse_pos)
		return

	# var dir := Vector2.ZERO
	# dir.y = Input.get_axis("ui_up", "ui_down")
	# dir.x = Input.get_axis("ui_left", "ui_right")
	# walk_to(global_position + dir * speed)


func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		if !walk_ended:
			walk_ended = true
			# emit_signal("walk", Vector2.ZERO, 0.0)
			emit_signal("walk_end")
		return

	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	_velocity += (desired_velocity - _velocity) * delta * 8.0
	_agent.set_velocity(_velocity)
	move_and_collide(_velocity * delta)
	emit_signal("walk", direction, _agent.max_speed)
