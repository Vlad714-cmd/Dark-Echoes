extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -400.0
@onready var chest: CharacterBody2D = $CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
var health := 3

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	add_to_group("player")

func _physics_process(delta):
	if is_dead:
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	_update_animation(direction)
	move_and_slide()

func _update_animation(direction):
	if is_dead:
		return
	elif not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

func die():
	is_dead = true
	velocity = Vector2.ZERO
	sprite.play("died")

func _on_animation_finished():
	if sprite.animation == "died":
		sprite.stop()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()
