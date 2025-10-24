extends Node

var player: Player

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_connection_failed():
	print("connection failed")

@rpc("authority", "call_local", "reliable")
func _enter_lobby() -> void:
	var lobby_packed: PackedScene = preload("res://entities/lobby/lobby.tscn")
	get_tree().change_scene_to_packed(lobby_packed)


func join_lobby():
	var peer = ENetMultiplayerPeer.new()
	print("Connecting to server %s on port %d..." % [ServerState.server_address, ServerState.PORT])
	var error = peer.create_client(ServerState.server_address, ServerState.PORT)
	if error:
		print("Failed to create client peer: %s" % str(error))
		return error

	multiplayer.multiplayer_peer = peer

func create_table(table_name: String):
	pass

func delete_table(_name):
	# Delete the specified table
	pass
	
func join_table(_name):
	# Join the table 
	pass
