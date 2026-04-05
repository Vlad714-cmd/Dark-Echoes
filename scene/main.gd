extends Node2D

@onready var music_player: AudioStreamPlayer = $musicplayer

func _ready() -> void:
	music_player.play() 

func stop_music() -> void:
	music_player.stop()
