extends Node

const SERVER_ADDRESS = '127.0.0.1'
const PORT = 42069
var players = {}
var player_info = {"name": "Name"}
var players_loaded = 0
var tables = {}


func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func join_lobby():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(LobbyState.SERVER_ADDRESS, LobbyState.PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	

func _on_connected_to_server():
	_register_player.rpc(player_info)
	


func update_lobby_players():
	pass



func _on_connection_failed():
	pass


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info

func create_table(_name):
	# Updates the tables dict with the new tables the client wants to add
	pass
	
func delete_table(_name):
	# Delete the specified table
	pass
	
func join_table(_name):
	# Join the table 
	pass
