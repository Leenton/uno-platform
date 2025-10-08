extends Node2D



func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		var server : Node = load("res://server/server.gd").new()
		server.name = "Server"
		add_child(server)
		print("Server started.")
	else:
		var server = load("res://server/server.gd").new()
		server.name = "Server"
		add_child(server)
		print("Server started.")
