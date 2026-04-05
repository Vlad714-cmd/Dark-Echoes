extends Area2D

@export var next_scene: String = "res://scene/cave.tscn"
@onready var sfx_player = $AudioStreamPlayer2D

var player_inside: bool = false
var is_transitioning: bool = false

func _process(_delta: float) -> void:
	if player_inside and not is_transitioning and Input.is_action_just_pressed("Portal"):
		_start_transition()

func _start_transition() -> void:
	is_transitioning = true
	
	if sfx_player and sfx_player.stream:
		sfx_player.play()
		var duration = sfx_player.stream.get_length()
		await get_tree().create_timer(duration).timeout
	
	if not is_inside_tree():
		return
	
	get_tree().change_scene_to_file(next_scene)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
