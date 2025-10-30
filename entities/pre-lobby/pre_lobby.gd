extends Node

@onready var name_text_edit := $Control/HBoxContainer/VBoxContainer/HBoxContainer/NameTextEdit
@onready var join_button := $Control/HBoxContainer/VBoxContainer/JoinLobbyButton

func _ready() -> void:
	name_text_edit.text = ClientState.player_name
	join_button.pressed.connect(_on_join_button_pressed)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func _on_join_button_pressed() -> void:
	var player_name : String = name_text_edit.text.strip_edges()
	
	if (len(player_name) == 0):
		return

	ClientState.set_player_name_value(player_name)

	print("Attempting to connect to server...")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ServerState.server_address, ServerState.port)
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
