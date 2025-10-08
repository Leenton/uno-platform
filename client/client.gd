extends Node

func join_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(LobbyState.SERVER_ADDRESS, LobbyState.PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	
