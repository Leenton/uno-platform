extends Node


func _process(_delta: float) -> void:
	_map_event(EventBus.read())


func _map_event(event : Event):
	match(event.type):
		Event.Type.PLAYER_JOINED:
			_player_joined(event)


func _player_joined(event : Event):
	pass



#func _ready():
	#multiplayer.peer_connected.connect(_on_peer_connected)
	#multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	#create_lobby()
#
#
#func create_lobby():
	#var peer = ENetMultiplayerPeer.new()
	#var error = peer.create_server(PORT, MAX_CONNECTIONS)
	#if error:
		#return error
	#multiplayer.multiplayer_peer = peer
#
#
#func _on_peer_connected(id):
	#print("Client connected: %s" % id)
#
#func _on_peer_disconnected(id):
	#print("Client disconnected: %s" % id)
