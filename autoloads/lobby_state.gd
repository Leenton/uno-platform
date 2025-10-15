extends Node

const SERVER_ADDRESS = '127.0.0.1'
const PORT = 42069
var players = {}
var player_info = {}
var players_loaded = 0
var tables = {}

signal updated_lobby_player_list

func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func _on_connected_to_server():
	_register_player.rpc_id(1, player_info)

func _on_connection_failed():
	pass

@rpc("authority", "reliable")
func _sync_players(updated_players):
	players = updated_players
	print("Players updated:", players)
	emit_signal("updated_lobby_player_list")

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	players[new_player_info['name']] = {
		"name": new_player_info['name'],
		"id": multiplayer.get_remote_sender_id()
	}
	_sync_players.rpc(players)
	
func join_lobby():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(LobbyState.SERVER_ADDRESS, LobbyState.PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func create_table(table_name: String):
	# Create a new table with the user who requested it as the first player
	_create_table.rpc_id(1, {
		"name": table_name,
		"players": [player_info['name']],
		"rules": [],
		"max_players": 12,
		"state": "Waiting to start game"
	})

@rpc("any_peer", "reliable")
func _create_table(table: Dictionary):
	tables[table["name"]] = table
	_sync_tables.rpc(tables)

@rpc("authority", "reliable")
func _sync_tables(updated_tables):
	tables = updated_tables

func delete_table(_name):
	# Delete the specified table
	pass
	
func join_table(_name):
	# Join the table 
	pass

func update_tables():
	pass
