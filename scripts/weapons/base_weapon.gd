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

@export var _projectile_spread_deg: float
@export var _projectile_count: int = 1

@export var _recoil: float

@export var _secondary_sound_delay_ratio: float

var _projectile_spread: float
var _shot_timer: float
var _swap_timer: float
var _secondary_sound_delay

@onready var _muzzle = $muzzle
@onready var _trajectory = $trajectory
@onready var _fire_sound = $Fire_sound
@onready var _secondary_sound = $Secondary_sound

#### ASSET/NODE EXPORTS ####
@export var projectile_scene: PackedScene

#### CALLBACKS ####
func _ready():
	_projectile_spread = (PI / 180) * _projectile_spread_deg
	_shot_timer = 0
	_swap_timer = _swap_cooldown

	_secondary_sound_delay = _shot_cooldown - (_shot_cooldown * _secondary_sound_delay_ratio)

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if _swap_timer >= 0:
		_swap_timer -= delta
	else:
		can_swap = true

	if is_selected:
		if _shot_timer >= _secondary_sound_delay:
			_secondary_sound.play()	

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

	_fire_sound.play()
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
			var shot_unit_trajectory = unit_trajectory

			#Bellow is a rotation matrix; TODO: make utils file and figure out why this denormalizes the vector
			shot_unit_trajectory.x = (shot_unit_trajectory.x * cos(current_shot_angle)) - (shot_unit_trajectory.y * sin(current_shot_angle))
			shot_unit_trajectory.y = (shot_unit_trajectory.x * sin(current_shot_angle)) + (shot_unit_trajectory.y * cos(current_shot_angle))

			var projectile = projectile_scene.instantiate()
			add_child(projectile)
			
			projectile.initialize(_muzzle.global_position, entity_velocity, shot_unit_trajectory.normalized())
			projectile.reparent($"/root/World")
	
	_do_recoil()
	
	_shot_timer = _shot_cooldown
	can_shoot = false
