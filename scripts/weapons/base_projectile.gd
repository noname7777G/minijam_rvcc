extends Area2D
class_name projectile

#### EXPORT PROPERTIES ###
@export var damage: float

@export var speed: float

@export var max_range: float
@export var time_limit: float

#### PUBLIC PROPERTIES ####
var velocity: Vector2

#### PRIVATE PROPERTIES ####
var _shooter: Node2D

var _timer: float
var _remaining_range: float

#### CALLBACKS ####
func _init():
	_shooter = owner
	_timer = time_limit
	_remaining_range = max_range

func _ready():
	reparent($"/world")
	$sprite.look_at() #Do this better.

func _process(delta: float) -> void:
	var new_pos = velocity * speed * delta
	position += new_pos

	$sprite.look_at() #Do this better.

	_timer -= delta

	_remaining_range -= new_pos.length()

#### SIGNALS ####
func _on_bullet_body_entered(body: CharacterBody2D):
	if body != _shooter:
		queue_free()
		body._on_bullet_body_entered(damage)

