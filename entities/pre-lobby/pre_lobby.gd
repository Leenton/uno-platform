extends Node

@onready var name_text_edit := $Control/HBoxContainer/VBoxContainer/HBoxContainer/NameTextEdit
@onready var join_button := $Control/HBoxContainer/VBoxContainer/JoinLobbyButton

func _ready() -> void:
	join_button.pressed.connect(_on_join_button_pressed)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func _on_join_button_pressed() -> void:
	var player_name : String = name_text_edit.text.strip_edges()
	
	if (len(player_name) == 0):
		return

	print("Attempting to connect to server...")
	ClientState.player_name = player_name
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ServerState.SERVER_ADDRESS, ServerState.PORT)
	if error != OK:
		print("Failed to create client peer: %s" % error)

	multiplayer.multiplayer_peer = peer

func _on_connection_failed() -> void:
	print("Connection to server failed. For some unknown reason")

func _on_connected_to_server() -> void:
	print("Connected to server successfully.")
	EventBus.push(
		Event.Type.PLAYER_CONNECTED,
		{'name' : ClientState.player_name}
	)







# @rpc("authority", "call_local", "reliable")
# func _enter_lobby() -> void:
# 	var lobby_packed: PackedScene = preload("res://entities/lobby/lobby.tscn")
# 	get_tree().change_scene_to_packed(lobby_packed)


# func join_lobby():
# 	var peer = ENetMultiplayerPeer.new()
# 	print("Connecting to server %s on port %d..." % [ServerState.server_address, ServerState.PORT])
# 	var error = peer.create_client(ServerState.server_address, ServerState.PORT)
# 	if error:
# 		print("Failed to create client peer: %s" % str(error))
# 		return error

# 	multiplayer.multiplayer_peer = peer

