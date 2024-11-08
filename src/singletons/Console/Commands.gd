extends GDScript
class_name Cmd

var fn: Callable
var arg_count: int
var help_text: String

func _init(p_fn: Callable, p_args: int, p_help: String):
	fn = p_fn
	arg_count = p_args
	help_text = p_help

static func initialize_commands():
	Console.add_command(
		"help",
		Cmd.new(
			func(args: Array[String]):
				Console.message("<--- Available Commands Are --->")
				var commands: Dictionary = Console.get_commands()
				for cmd_name in commands:
					Console.message("\t-%s - %s" % [cmd_name, commands[cmd_name].help_text])
				
				pass,
			0,
			"Lists the available commands"
			),
	)
	
	Console.add_command(
		"eval",
		Cmd.new(
			func(args: Array[String]):
				var s = ""
				for a in args:
					s += a + " "
				
				var expr := Expression.new()
				expr.parse(s)
				var result = expr.execute()
				if not result:
					Console.error("Could not evaluate expression!")
					return
				Console.message(s, ["= ",result])
				pass,
			1,
			"Evaluates an expression"
			),
	)
	
	Console.add_command(
		"echo",
		Cmd.new(
			func(args: Array[String]):
				var t := ""
				for a in args:
					t += a + " "
				t.rstrip(" ")
				Console.message(t)
				pass,
			1,
			"Prints the arguments to the console."
			),
	)
	
	Console.add_command(
		"clear",
		Cmd.new(
			func(args: Array[String]):
				Console.clear()
				pass,
			0,
			"Clears the console..."
			),
	)
	
	Console.add_command(
		"enable_vsync",
		Cmd.new(
			func(args: Array[String]):
				if args[0] == "0":
					DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
				elif args[0] == "1":
					DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
				else:
					Console.error("Invalid argument")
				pass,
			1,
			"pass 0 or 1 to enable or disable VSync."
			),
	)
	
	Console.add_command(
		"max_fps",
		Cmd.new(
			func(args: Array[String]):
				var set_fps = int(args[0])
				if set_fps == 0:
					Console.error("Invalid argument")
					return
				Engine.max_fps = set_fps
				pass,
			1,
			"pass an integer to set the max fps to."
			),
	)
	
	Console.add_command(
		"reset_settings",
		Cmd.new(
			func(args: Array[String]):
				SettingsManager.clear_settings()
				pass,
			0,
			"Resets to default settings"
			),
	)
	
	Console.add_command(
		"visible_hurtboxes",
		Cmd.new(
			func(args: Array[String]):
				if args[0] == "0":
					AttackHurtbox.visible_hitboxes = false
				elif args[0] == "1":
					AttackHurtbox.visible_hitboxes = true
				else:
					Console.error("Invalid argument")
				pass,
			1,
			"pass 0 or 1 to enable or disable visibility."
			),
	)
	
	Console.add_command(
		"get_action_events",
		Cmd.new(
			func(args: Array[String]):
				if not InputMap.has_action(args[0]):
					Console.error("no action called %s exists!" % args[0])
					return
				
				var inputs = InputMap.action_get_events(args[0])
				
				Console.message(JSON.stringify(inputs, "  ", ))
				
				pass,
			1,
			"pass 0 or 1 to enable or disable visibility."
			),
	)
	
	pass
