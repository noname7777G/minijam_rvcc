extends Node2D
class_name base_weapon

#### PUBLIC PROPERTIES ####
@export var energy_cost: float
@export var is_automatic: bool = false

var is_selected: bool
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

	if _swap_timer >= 0:
		_swap_timer -= delta
	else:
		can_swap = true

	if is_selected:
		if _shot_timer >= 0:
			_shot_timer -= delta
		else:
			can_shoot = true

#### PRIVATE FUNCTIONS ####
func _do_recoil():
	if "velocity" in owner:
		owner.velocity.x += cos(owner.rotation) * -_recoil * 100
		owner.velocity.y += sin(owner.rotation) * -_recoil * 100

#### PUBLIC METHODS ####
func swap_to():
	_swap_timer = _swap_cooldown
	is_selected = true
	can_swap = false
	visible = true

func swap_from():
	is_selected = false
	visible = false

func shoot(entity_velocity: Vector2):
	if !can_shoot:
		return

	var unit_trajectory: Vector2 = _trajectory.global_position - global_position

	if _projectile_count == 1:
		var projectile = projectile_scene.instantiate()
	
		add_child(projectile)
		projectile.initialize(_muzzle.global_position, entity_velocity, unit_trajectory)

		projectile.reparent($"/root/World")

	else:
		var start_angle = -(_projectile_spread / 2)
		var between_angle = _projectile_spread / (_projectile_count - 1)


		for p in range(_projectile_count):
			var current_shot_angle = start_angle + (between_angle * p)

			unit_trajectory.x = (unit_trajectory.x * cos(current_shot_angle)) - (unit_trajectory.y * sin(current_shot_angle))
			unit_trajectory.y = (unit_trajectory.x * sin(current_shot_angle)) + (unit_trajectory.y * cos(current_shot_angle))

			var projectile = projectile_scene.instantiate()
			add_child(projectile)

			projectile.initialize(_muzzle.global_position, entity_velocity, unit_trajectory)
			projectile.reparent($"/root/World")
	
	_do_recoil()
	
	_shot_timer = _shot_cooldown
	can_shoot = false
