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
	_register_player.rpc_id(1, player_info)
	
func update_lobby_players():
	pass

func _on_connection_failed():
	pass

@rpc("authority", "reliable")
func _sync_players(updated_players):
	players = updated_players
	print(players)

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	players[new_player_info['name']] = {
		"name": new_player_info['name'],
		"id": multiplayer.get_remote_sender_id()
	}
	_sync_players.rpc(players)
	print("sync called")

func create_table(_name):
	# Updates the tables dict with the new tables the client wants to add
	pass
	
func delete_table(_name):
	# Delete the specified table
	pass
	
func join_table(_name):
	# Join the table 
	pass

func display_tables():
	pass