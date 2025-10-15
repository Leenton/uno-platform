extends Node

const SERVER_ADDRESS = '127.0.0.1'
const PORT = 42069
var players = {}
var player: Player
var players_loaded = 0
var tables = {}

signal updated_lobby_player_list

func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_disconnected.connect(_player_disconnected)

func _on_connected_to_server():
	_handle_new_player.rpc_id(1, player)

func _on_connection_failed():
	pass
	
func _player_disconnected(player_id):
	players[player_id]['connection_status'] = Player.ConnectionStatus.DISCONNECTED
	_sync_players.rpc(1, players)
	emit_signal("player_disconnected", player_id)

@rpc("authority", "reliable")
func _sync_players(updated_players):
	players = updated_players
	print("Players updated:", players)
	emit_signal("updated_lobby_player_list")

@rpc("any_peer", "reliable")
func _handle_new_player(new_player: Player):
	# If the player had previously connected we need to update 
	if len(new_player.name) == 0:
		return
	
	if(players[new_player.name.to_lower()] and players[new_player.name.to_lower()]["connection_status"] == Player.ConnectionStatus.CONNECTED):
		return
	
	players[new_player.name.to_lower()]["name"] = new_player.name
	players[new_player.name.to_lower()]["id"] = multiplayer.get_remote_sender_id()
	players[new_player.name.to_lower()]["connection_status"] = Player.ConnectionStatus.CONNECTED
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
		"players": [player.name],
		"spectators": [],
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
