extends CharacterBody2D

@export var speed := 80.0
@export var chase_speed := 100.0        
@export var damage := 1
@export var patrol_distance := 100.0
@export var detection_range := 200.0   

@onready var sprite = $AnimatedSprite2D
@onready var sfx_ambient = $AudioStreamPlayer2D

var direction := 1.0
var start_x: float
var player: Node = null
var is_chasing := false

const GRAVITY = 900.0

func _ready() -> void:
	start_x = global_position.x
	player = get_tree().get_first_node_in_group("player")
	
	if sfx_ambient:
		sfx_ambient.bus = "sfx" 

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	_check_player_detection()

	if is_chasing and player:
		_chase_player()
	else:
		_patrol()
		
	if abs(velocity.x) > 1:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
	
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

	move_and_slide()
	_handle_movement_sound()

func _handle_movement_sound() -> void:
	if sfx_ambient:
		if is_on_floor() and abs(velocity.x) > 10:
			if not sfx_ambient.playing:
				sfx_ambient.pitch_scale = randf_range(0.85, 1.15)
				sfx_ambient.play()
		else:
			sfx_ambient.stop()

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
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
