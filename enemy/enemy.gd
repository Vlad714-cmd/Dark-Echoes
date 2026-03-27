extends CharacterBody2D

@export var speed := 80.0
@export var damage := 1
@export var patrol_distance := 100.0

@onready var sprite = $AnimatedSprite2D

var direction := 1.0
var start_x: float

const GRAVITY = 900.0

func _ready() -> void:
	start_x = global_position.x

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity.x = speed * direction
	if global_position.x > start_x + patrol_distance:
		direction = -1.0
		sprite.flip_h = true
	elif global_position.x < start_x - patrol_distance:
		direction = 1.0
		sprite.flip_h = false
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
