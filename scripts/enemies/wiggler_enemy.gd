extends Node2D

@onready var _body = $CharacterBody2D
@onready var _head = $CharacterBody2D/head
@onready var _thorax = $CharacterBody2D/thorax
@onready var _abdomen = $CharacterBody2D/abdomen
@onready var _tail = $CharacterBody2D/tail

@onready var _animation_player = $CharacterBody2D/AnimationPlayer

@export var health: float = 20.0
@export var speed: float = 20.0

var state = "idle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "search":
		pass
	
	if state == "lunge":
		pass
		
	if state == "turn":
		pass
		
	if state == "move":
		pass
	
func on_hit(damage: float):
	health -= damage

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
