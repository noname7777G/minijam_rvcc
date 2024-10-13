extends Node2D

@onready var _head = $head
@onready var _thorax = $thorax
@onready var _abdomen = $abdomen
@onready var _tail = $tail

@export var health: float = 20.0
@export var speed: float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_hit(damage: float):
	health -= damage
