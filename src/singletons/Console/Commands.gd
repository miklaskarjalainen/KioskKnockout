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
	
	pass
