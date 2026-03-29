extends CanvasLayer

@onready var soundBar = $HBoxContainer/VBoxContainer/soundBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soundBar.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sound"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_sound_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sound"), value)


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menu.tscn")
