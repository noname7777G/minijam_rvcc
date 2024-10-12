extends Node2D
class_name base_weapon

#### EXPORTED PROPERTIES ####
@export var shot_cooldown: float
@export var swap_cooldown: float

@export var projectile_spread: float
@export var projectile_count: int = 1

@export var energy_cost: float

@export var recoil: float
@export var is_automatic: bool = false

#### PRIVATE PROPERTIES ####
var _shot_timer: float
var _swap_timer: float

#### ASSET/NODE EXPORTS ####
@export var muzzle: Marker2D
@export var trajectory: Marker2D

@export var projectile_scene: PackedScene

@export var on_expire_scene: PackedScene

#### CALLBACKS ####
func _init():
	_shot_timer = 0
	_swap_timer = 0

func _process(delta: float) -> void:
	if !is_zero_approx(_swap_timer):
		_swap_timer -= delta
	else:
		_swap_timer = 0

	if !is_zero_approx(_shot_timer):
		_shot_timer -= delta
	else:
		_shot_timer = 0

#### PRIVATE FUNCTIONS ####
func _do_recoil():
	pass

#### PUBLIC METHODS ####
func shoot(entity_velocity: Vector2):
	if _shot_timer != 0:
		return
	
	if projectile_count > 1:
		pass
	else:
		pass

	_do_recoil()

	_shot_timer = shot_cooldown


