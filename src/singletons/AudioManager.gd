extends Node

enum Audio_Player { Music, UI, SFX }

@onready var _music_player: AudioStreamPlayer = $BGMusicPlayer
@onready var _ui_player: AudioStreamPlayer = $UISoundPlayer
@onready var _sfx_player: AudioStreamPlayer = $SFXSoundPlayer

var master_volume: float
var music_volume: float
var ui_volume: float
var sfx_volume: float

func _ready() -> void:
	AudioManager.play("res://assets/sounds/music/Generating Worlds.ogg", AudioManager.Audio_Player.Music)

func play(fpath: String, audio_channel: Audio_Player) -> AudioStreamPlayer:
	var audio_player: AudioStreamPlayer
	match audio_channel:
		Audio_Player.Music:
			audio_player = _music_player
		Audio_Player.UI:
			audio_player = _ui_player
		Audio_Player.SFX:
			audio_player = _sfx_player
	
	audio_player.stream = AudioStreamOggVorbis.load_from_file(fpath)
	audio_player.play()
	return audio_player

func update_audio_server() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(ui_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
