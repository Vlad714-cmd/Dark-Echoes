extends Area2D

@export var next_scene: String = "res://scence/cave.tscn"

var player_inside: bool = false


func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("Portal"):
		get_tree().change_scene_to_file(next_scene)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
