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
				Console.message("you called out for help")
				pass,
			0,
			"this is help"
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
