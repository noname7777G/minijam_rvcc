extends Area2D
class_name base_projectile

#### EXPORT PROPERTIES ###
@export var damage: float

@export var speed: float

@export var max_range: float
@export var time_limit: float

#### PUBLIC PROPERTIES ####

#### PRIVATE PROPERTIES ####
var _shooter: Node2D
var _initial_velocity: Vector2
var _trajectory: Vector2

var _timer: float
var _remaining_range: float

@onready var _sprite = $Sprite2D

#### NODE/ASSET EXPORTS ####
@export var on_expire_scene: PackedScene

#### PUBLIC METHODS ####
func initialize(init_velocity: Vector2, trajectory: Vector2):
	_initial_velocity = init_velocity
	_trajectory = trajectory
	look_at(global_position + _trajectory)

#### CALLBACKS ####
func _init():
	_shooter = owner
	_timer = time_limit
	_remaining_range = max_range

func _process(delta: float) -> void:
	var new_pos = (_trajectory * speed * delta) + _initial_velocity
	position += new_pos

	_sprite.look_at(position + new_pos) #Do this better.
	
	if !is_zero_approx(_timer):
		_timer -= delta
	else:
		queue_free()
	
	if !is_zero_approx(_remaining_range):
		_remaining_range -= new_pos.length()
	else:
		queue_free()

#### SIGNALS ####
func _on_body_entered(body:Node2D) -> void:
	if body != _shooter:
		queue_free()
		var body_class = body.get_class()

		if body_class == "base_entity":
			body.on_hit(damage)
