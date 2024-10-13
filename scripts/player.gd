extends CharacterBody2D

#### EXPORT PROPERTIES ####
@export var max_speed: float = 400
@export var accel: float = 10

@export var max_energy: float = 100
@export var base_energy_loss: float = 1
@export var movement_energy_loss: float = 1

@export var auto_gun_scene: base_weapon
@export var shotgun_scene: base_weapon
@export var shuriken_scene: base_weapon
@export var grenade_scene: base_weapon

#### PRIVATE PROPERTIES ####
var _user_movement_input: Vector2

var _current_energy: float

var _current_weapon: base_weapon

#### PRIVATE FUNCTIONS ####
func _swap_weapons():
	if _current_weapon.can_swap:
		pass

func _get_user_input():
	_user_movement_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_user_movement_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_user_movement_input = _user_movement_input.normalized()

	look_at(get_global_mouse_position())

	if Input.is_action_pressed("swap_to_auto_gun"):
		_current_weapon = auto_gun_scene

	if Input.is_action_pressed("swap_to_shotgun"):
		_current_weapon = shotgun_scene

	if Input.is_action_pressed("swap_to_shuriken"):
		_current_weapon = shuriken_scene

	if Input.is_action_pressed("Swap_to_grenade"):
		_current_weapon = grenade_scene

	if _current_weapon.is_automatic:
		if Input.is_action_pressed("shoot") && _current_weapon.can_shoot:
			_current_weapon.shoot(velocity)
	else:
		if Input.is_action_just_pressed("shoot"): #### fire gun here
			_current_weapon.shoot(velocity)

func _do_energy_cost(delta):
	_current_energy -= delta * base_energy_loss

	if !is_zero_approx(_user_movement_input.x) and !is_zero_approx(_user_movement_input.y):
		_current_energy -= delta * movement_energy_loss

#### CALLBACKS ####
func _ready():
	_current_weapon = auto_gun_scene
	_current_energy = max_energy

func _process(delta: float) -> void:

	_get_user_input()
	velocity = velocity.lerp(max_speed * _user_movement_input, delta * accel)
	
	_do_energy_cost(delta)
	move_and_slide()

#### SIGNALS ####
func _on_bullet_body_entered(_body: Node2D) -> void:
	print("I'm hit!")
