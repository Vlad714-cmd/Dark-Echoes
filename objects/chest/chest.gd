extends Node2D

var player_nearby = false
var is_open = false

@onready var anim = $AnimatedSprite2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("interact") and not is_open:
		open_chest()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false

func open_chest():
	is_open = true
	anim.play("opening")  
