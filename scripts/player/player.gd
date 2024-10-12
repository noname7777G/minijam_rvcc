extends CharacterBody2D

#### EXPORT PROPERTIES ####

@export var max_speed: float = 400
@export var accel: float = 10

@export var max_energy: int = 100

#### PRIVATE PROPERTIES ####

var _user_movement_input: Vector2

var _weapons = {
	"auto_gun": base_weapon.new(),
	"shotgun": base_weapon.new(),
	"shuriken": base_weapon.new(),
	"grenade": base_weapon.new(),
	}

var _current_energy: int

#### PRIVATE FUNCTIONS ####

func _get_user_input():
	_user_movement_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_user_movement_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_user_movement_input = _user_movement_input.normalized()

	look_at(get_global_mouse_position())

#### CALLBACKS ####

func _process(delta: float) -> void:
	_get_user_input()
	
	if Input.is_action_just_pressed("shoot"): #### fire gun here
		pass
	
	velocity = velocity.lerp(max_speed * _user_movement_input, delta * accel)
	
	move_and_slide()

#### SIGNALS ####

func _on_bullet_body_entered(_body: Node2D) -> void:
	print("I'm hit!")
