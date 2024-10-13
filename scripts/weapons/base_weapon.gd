extends Node2D
class_name base_weapon

#### PUBLIC PROPERTIES ####
@export var energy_cost: float
@export var is_automatic: bool = false

var can_shoot: bool
var can_swap: bool

#### PRIVATE PROPERTIES ####
@export var _shot_cooldown: float
@export var _swap_cooldown: float

@export var _projectile_spread: float
@export var _projectile_count: int = 1

@export var _recoil: float

var _shot_timer: float
var _swap_timer: float

@onready var _muzzle = $muzzle
@onready var _trajectory = $trajectory

#### ASSET/NODE EXPORTS ####
@export var projectile_scene: PackedScene

#### CALLBACKS ####
func _init():
	_shot_timer = 0
	_swap_timer = 0

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if !is_zero_approx(_swap_timer):
		_swap_timer -= delta
	else:
		can_swap = true

	if !is_zero_approx(_shot_timer):
		_shot_timer -= delta
	else:
		can_shoot = true

#### PRIVATE FUNCTIONS ####
func _do_recoil():
	pass

#### PUBLIC METHODS ####
func swap_to():
	_swap_timer = _swap_cooldown
	can_swap = false

func shoot(entity_velocity: Vector2):
	if !can_shoot:
		print("oof")
		return
	
	if _projectile_count == 1:
		var projectile = projectile_scene.instantiate()
	
		projectile.initialize(entity_velocity, _trajectory.position)

		projectile.visible = true
		projectile.reparent($"/World")
	else:
		var start_angle = -(_projectile_spread / 2)
		var between_angle = _projectile_spread / _projectile_count

		var projectile_trajectory: Vector2

		for p in range(_projectile_count):
			var current_shot_angle = start_angle + (between_angle * p)

			projectile_trajectory.x = cos(current_shot_angle)
			projectile_trajectory.y = sin(current_shot_angle)

			var projectile = projectile_scene.instantiate()

			projectile.initialize(entity_velocity, projectile_trajectory)
			projectile.reparent($"World")
	
	_do_recoil()
	
	_shot_timer = _shot_cooldown
	can_shoot = false
