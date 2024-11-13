extends Node

enum Audio_Player { Background, UI, SFX }

@onready var _bg_music_player: AudioStreamPlayer = $BGMusicPlayer
@onready var _ui_sound_player: AudioStreamPlayer = $UISoundPlayer
@onready var _sfx_sound_player: AudioStreamPlayer = $SFXSoundPlayer

var master_volume: float
var music_volume: float
var ui_volume: float
var sfx_volume: float

func play(fpath: String, audio_channel: Audio_Player, loop: bool = false) -> void:
	pass

func update_audio_server() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	## FIXME: For some reason the Music audio bus does not change, figure this out later.
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(ui_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
