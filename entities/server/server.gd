extends Node

const PORT = 42069
const MAX_CONNECTIONS = 4095

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	create_lobby()


func create_lobby():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer


func _on_peer_connected(id):
	print("Client connected: %s" % id)

func _on_peer_disconnected(id):
	print("Client disconnected: %s" % id)
