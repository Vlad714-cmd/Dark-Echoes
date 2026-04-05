extends Node2D


@onready var music_player: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	music_player.play() # почати відтворення музики

func stop_music() -> void:
	music_player.stop() # зупинити відтворення музики
