extends CharacterBody2D

@export var speed := 80.0
@export var chase_speed := 100.0        
@export var damage := 1
@export var patrol_distance := 100.0
@export var detection_range := 150.0  

@onready var sprite = $AnimatedSprite2D
@onready var sfx_ambient = $AudioStreamPlayer2D

const GRAVITY = 900.0

var direction := 1.0
var start_x: float
var player: Node = null
var is_chasing := false

func _ready() -> void:
	start_x = global_position.x
	player = get_tree().get_first_node_in_group("player")
	
	if sfx_ambient:
		sfx_ambient.bus = "sfx" 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	_check_player_detection()

	if is_chasing and player:
		_chase_player()
	else:
		_patrol()

	move_and_slide()
	

	_update_animations()
	_handle_movement_sound()

func _check_player_detection() -> void:
	if not player:
		is_chasing = false
		return
		
	var dist = global_position.distance_to(player.global_position)
	is_chasing = dist <= detection_range

func _chase_player() -> void:
	var diff = player.global_position.x - global_position.x
	
	if abs(diff) > 10:
		direction = sign(diff)
		velocity.x = direction * chase_speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func _patrol() -> void:
	if global_position.x > start_x + patrol_distance:
		direction = -1.0
	elif global_position.x < start_x - patrol_distance:
		direction = 1.0
		
	velocity.x = direction * speed

func _update_animations() -> void:
	if abs(velocity.x) > 5.0:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
	
	
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func _handle_movement_sound() -> void:
	if sfx_ambient:
		if is_on_floor() and abs(velocity.x) > 10:
			if not sfx_ambient.playing:
				sfx_ambient.pitch_scale = randf_range(0.85, 1.15)
				sfx_ambient.play()
		else:
			if sfx_ambient.playing:
				sfx_ambient.stop()
