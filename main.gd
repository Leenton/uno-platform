extends Node2D

@export var server_mode = false

func _ready() -> void:
	if OS.has_feature("dedicated_server") or server_mode:
		print("Server started.")
	else:
		print("starting")
		var pre_lobby : PackedScene = load("res://entities/pre-lobby/pre_lobby.tscn")
		var lobby_instance = pre_lobby.instantiate()
		add_child(lobby_instance)
		print("Lobby started.")
 
