extends Node2D
class_name base_weapon

#### PUBLIC PROPERTIES ####

var shot_cooldown: float

var swap_cooldown: float

var energy_cost: float

var recoil: float

var bullet_speed: float
var bullet_spread: float
var bullet_count: float
var bullet_range: float

var is_automatic: bool

#### PRIVATE PROPERTIES ####

var _shot_timer: float
var _swap_timer: float

#### ASSET/NODE EXPORTS ####

@export var muzzle: Marker2D
#@export var bullet_tex: ???? need guidance

#### CALLBACKS ####

func _init():
	_shot_timer = 0
	_swap_timer = 0

#### PRIVATE METHODS ####

func _do_recoil():
	pass

#### PUBLIC METHODS ####

func do_cooldowns(delta: float):
	if !is_zero_approx(_swap_timer):
		_swap_timer -= delta
	else:
		_swap_timer = 0

	if !is_zero_approx(_shot_timer):
		_shot_timer -= delta
	else:
		_shot_timer = 0

func shoot(entity_velocity: Vector2):
	pass
