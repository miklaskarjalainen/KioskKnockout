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
	_sfx_player.play()
	AudioManager.play("res://assets/sounds/music/Generating Worlds.ogg", AudioManager.Audio_Player.Music)

func play(fpath: String, audio_channel: Audio_Player) -> AudioStreamPlayer:
	var audio_player: AudioStreamPlayer
	var stream: AudioStream = AudioStreamOggVorbis.load_from_file(fpath)
	
	match audio_channel:
		Audio_Player.Music:
			audio_player = _music_player
		Audio_Player.UI:
			audio_player = _ui_player
		Audio_Player.SFX:
			var playback := _sfx_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
			playback.play_stream(stream, 0, 0, randf_range(0.85, 1.15))
			return _sfx_player
		_:
			Console.error("AudioManager: INVALID CHANNEL")
	
	audio_player.stream = stream
	audio_player.play()
	return audio_player

func update_audio_server() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(ui_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
