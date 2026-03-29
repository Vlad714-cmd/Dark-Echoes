extends CharacterBody2D

@export var speed := 80.0
@export var chase_speed := 100.0        
@export var damage := 1
@export var patrol_distance := 100.0
@export var detection_range := 100.0    

@onready var sprite = $AnimatedSprite2D

var direction := 1.0
var start_x: float
var player: Node = null
var is_chasing := false

const GRAVITY = 900.0

func _ready() -> void:
	start_x = global_position.x
	
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	_check_player_detection()

	if is_chasing and player:
		_chase_player()
	else:
		_patrol()

	move_and_slide()

func _check_player_detection() -> void:
	if not player:
		return
	var dist = global_position.distance_to(player.global_position)
	is_chasing = dist <= detection_range

func _chase_player() -> void:
	var diff = player.global_position.x - global_position.x
	direction = sign(diff)
	velocity.x = chase_speed * direction
	sprite.flip_h = direction < 0

func _patrol() -> void:
	velocity.x = speed * direction
	if global_position.x > start_x + patrol_distance:
		direction = -1.0
		sprite.flip_h = true
	elif global_position.x < start_x - patrol_distance:
		direction = 1.0
		sprite.flip_h = false

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
