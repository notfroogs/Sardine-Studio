extends Node

func _ready() -> void:
	var loaded_file := FileAccess.open("res://chart1.txt", FileAccess.READ)
	print(type_string(typeof(loaded_file)))
	print(loaded_file.get_line())
	print(loaded_file.get_line())
	print(len(loaded_file.get_line()))
	#print(type_string(typeof(loaded_file.get_line())))
	print(loaded_file.get_line())
	#if loaded_file:
		#while not loaded_file.eof_reached():
			#var content = loaded_file.get_line()
			#print(content)
			##print(type_string(typeof(content)))
			#var dictionary = {}
			#var items = content.split(",")
			#print(items)
			#for item in items:
				#var keys = item.split(":")
				##dictionary[keys[0].strip_edges()] = keys[1].strip_edges()
			#print(dictionary)
			#print(dictionary["level"])
		#loaded_file.close()
		
