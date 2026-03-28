extends Node2D

func _ready() -> void:
	$bg_1.scroll_scale = Vector2(0.15, 0.0)
	$bg_1.repeat_size = Vector2(320, 0)
	
	$bg_2.scroll_scale = Vector2(0.35, 0.0)
	$bg_2.repeat_size = Vector2(320, 0)
	
	$bg_3.scroll_scale = Vector2(0.6, 0.0)
	$bg_3.repeat_size = Vector2(320, 0)

func _process(_delta: float) -> void:

	$bg_1.global_position.y = 0
	$bg_2.global_position.y = 0
	$bg_3.global_position.y = 0
