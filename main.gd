extends Node2D

func _ready() -> void:
	if OS.has_feature("dedicated_server") or Debugger.server_mode:
		var server : Node = load("res://server/server.gd").new()
		server.name = "Server"
		add_child(server)
		print("Server started.")
	else:
		print("starting")
		var client : Node = load("res://client/client.gd").new()
		client.name = "Client"
		add_child(client)
		client.load_scenes()
		print("Client Side Game Started.")