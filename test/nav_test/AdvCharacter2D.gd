tool
extends KinematicBody2D
class_name AdventureCharacter2D

export var speed := 100.0 setget _set_speed, _get_speed
export var input_disabled := false setget _set_input_disabled, _get_input_disabled
onready var _agent := $NavigationAgent2D as NavigationAgent2D

var _velocity := Vector2.ZERO


func _enter_tree():
	if !Engine.editor_hint:
		return

	var root = get_tree().edited_scene_root
	if !has_node("NavigationAgent2D"):
		_agent = NavigationAgent2D.new()
		add_child(_agent)
		_agent.owner = root

	if !has_node("CollisionShape2D"):
		var collision = CollisionShape2D.new()
		collision.shape = CapsuleShape2D.new()
		add_child(collision)
		collision.owner = root


func _set_input_disabled(disabled: bool):
	set_process_input(!disabled)
	_agent.avoidance_enabled = !disabled


func _get_input_disabled() -> bool:
	return !is_processing_input()


func _input(event):
	if not event.is_action_pressed("left_click"):
		return

	var mouse_pos := get_global_mouse_position()
	move_to(mouse_pos)


func move_to(location: Vector2):
	_agent.set_target_location(location)


func _set_speed(value: float):
	_agent.max_speed = value


func _get_speed() -> float:
	return _agent.max_speed


func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		return

	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	_velocity += (desired_velocity - _velocity) * delta * 8.0
	_agent.set_velocity(_velocity)
	move_and_collide(_velocity * delta)
