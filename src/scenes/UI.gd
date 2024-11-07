extends Control
class_name UI

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var title_screen: Control = $TitleScreen
@onready var options_menu: OptionsMenu = $OptionsMenu

func _ready() -> void:
	Global.OptionsOpened.connect(func () -> void:
		title_screen.hide()
		options_menu.show()
		pass
	)
	Global.OptionsClosed.connect(func () -> void:
		options_menu.hide()
		title_screen.show()
		title_screen.set_focus()
		pass
	)
	Global.MasterVolumeChanged.connect(func (value: float) -> void:
		audio_stream_player.volume_db = (-(100 - value) / 2)
		if value == 0:
			audio_stream_player.stream_paused = true
		else:
			audio_stream_player.stream_paused = false
	)
	Global.MusicVolumeChanged.connect(func (value: float) -> void:
		audio_stream_player.volume_db = (-(100 - value) / 2)
		if value == 0:
			audio_stream_player.stream_paused = true
		else:
			audio_stream_player.stream_paused = false
	)
