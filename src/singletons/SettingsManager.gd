extends Node

class Settings:
	var version: int = 0
	
	func get_as_config() -> ConfigFile:
		var config := ConfigFile.new()
		
		# Generic
		config.set_value("generic", "version", version)
		
		# Graphics settings
		config.set_value("video", "vsync", DisplayServer.window_get_vsync_mode() as int)
		config.set_value("video", "max_fps", Engine.max_fps)
		
		# Keybinds
		var action_names: Array[StringName] = InputMap.get_actions().filter(
			func(action: StringName) -> bool:
				return action.begins_with("kb_")
		)
		var action_events: Array = action_names.map(func(action: StringName) -> Array:
			# Is Array[int], but typing it as that, makes the config file look horrible.
			var events: Array = [] 
			for ac in InputMap.action_get_events(action):
				events.push_back(ac["physical_keycode"])
			return events
		)
		
		for i in range(0, action_names.size()):
			config.set_value("binds", action_names[i], action_events[i])
		
		return config
	
	func load_from_config(config: ConfigFile) -> bool:
		config.get_value("generic", "version", version)
		
		# Graphics settings
		var vsync: int = config.get_value("video", "vsync", DisplayServer.window_get_vsync_mode() as int)
		DisplayServer.window_set_vsync_mode(vsync)
		Engine.max_fps = config.get_value("video", "max_fps", Engine.max_fps)
		
		# Keybinds
		var binds_keys: PackedStringArray = config.get_section_keys("binds")
		for action in binds_keys:
			var events: Array = config.get_value("binds", action, [])
			InputMap.action_erase_events(action)
			for ev_physcial_key in events:
				var input_event = InputEventKey.new()
				input_event.physical_keycode = ev_physcial_key
				InputMap.action_add_event(action, input_event)
			
		
		return true

@onready var default_settings := ConfigFile.new()
@onready var settings := Settings.new()
const SETTINGS_SAVE_PATH := "user://settings.ini"

func clear_settings():
	var err = DirAccess.remove_absolute(SETTINGS_SAVE_PATH)
	if err != OK:
		Console.warning("Settings file could not be deleted from %s!" % SETTINGS_SAVE_PATH)
	else:
		Console.message("Settings file succesfully deleted settings from %s!" % SETTINGS_SAVE_PATH)
	settings.load_from_config(default_settings)

func _save_settings(fpath: String):
	var config := settings.get_as_config()
	var err := config.save(fpath)
	if err != OK:
		Console.error("Could not save settings to '%s'" % fpath)
		return
	Console.message("Successfully saved settings to '%s'" % fpath);

func _open_settings(fpath: String):
	var config := ConfigFile.new()
	if config.load(fpath) != OK:
		Console.warning("Could not load settings from path %s!" % fpath)
		return
	if settings.load_from_config(config):
		Console.message("Succesfully loaded settings from '%s'" % fpath)

func _ready() -> void:
	default_settings = settings.get_as_config()
	_open_settings(SETTINGS_SAVE_PATH)

func _exit_tree() -> void:
	_save_settings(SETTINGS_SAVE_PATH)
