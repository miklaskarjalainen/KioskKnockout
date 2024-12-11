godot ./project.godot --headless --rendering-method gl_compatibility --export-release Web ./build/index.html 
tar -a -c -f web.zip ./build/index*
