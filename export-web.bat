godot ./project.godot --headless --export-release Web ./build/index.html
tar -a -c -f web.zip ./build/index*
