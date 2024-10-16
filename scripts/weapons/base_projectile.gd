extends Area2D
class_name base_projectile

#### EXPORT PROPERTIES ###
@export var damage: float

@export var speed: float

@export var max_range: float
@export var time_limit: float

#### PUBLIC PROPERTIES ####

#### PRIVATE PROPERTIES ####
var _initial_velocity: Vector2
var _trajectory: Vector2

var _timer: float
var _remaining_range: float

@onready var _sprite = $Sprite2D

#### NODE/ASSET EXPORTS ####
@export var on_expire_scene: PackedScene

#### PUBLIC METHODS ####
func initialize(init_position: Vector2, init_velocity: Vector2, trajectory: Vector2):
	global_position = init_position
	_initial_velocity = init_velocity	
	_trajectory = trajectory
	look_at(global_position + _trajectory)
	
	for grp_name in get_parent().get_parent().get_groups():
		add_to_group(grp_name)
	
	_timer = time_limit
	_remaining_range = max_range


#### CALLBACKS ####
func _process(delta: float) -> void:
	var new_pos = (_trajectory * speed * delta) + (_initial_velocity * delta)
	position += new_pos

	_sprite.look_at(position + _trajectory) #Do this better.
	
	if _timer >= 0:
		_timer -= delta
	else:
		queue_free()
	
	if _remaining_range >= 0:
		_remaining_range -= new_pos.length() * delta
	else:
		queue_free()

#### SIGNALS ####
func _on_body_entered(body:Node2D) -> void:
	for shooter_grp in get_groups():
		if body.is_in_group(shooter_grp):
			return
	
	queue_free()
	print("hit")

	if body.has_method("on_hit"):
		body.on_hit(damage)





	
