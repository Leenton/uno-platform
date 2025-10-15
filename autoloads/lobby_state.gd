extends Node

const PORT = 8080
var server_address = '127.0.0.1'
var players = {}
var player: Player
var players_loaded = 0
var tables = {}

signal updated_lobby_player_list


func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_connected_to_server():
	_handle_new_player.rpc_id(1, player.name)

func _on_connection_failed():
	print("connection failed")
	
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
func _handle_new_player(new_player_name: String) -> void:
	if new_player_name.is_empty():
		return

	var sender_id := multiplayer.get_remote_sender_id()
	var key := new_player_name.to_lower()

	if not players.has(key):
		players[key] = {}

	if players[key].get("connection_status") == Player.ConnectionStatus.CONNECTED:
		return

	players[key]["name"] = new_player_name
	players[key]["id"] = sender_id
	players[key]["connection_status"] = Player.ConnectionStatus.CONNECTED

	_sync_players.rpc(players)
	_enter_lobby.rpc_id(sender_id)


@rpc("authority", "call_local", "reliable")
func _enter_lobby() -> void:
	var lobby_packed: PackedScene = preload("res://entities/lobby/lobby.tscn")
	get_tree().change_scene_to_packed(lobby_packed)



func join_lobby():
	var peer = ENetMultiplayerPeer.new()
	print("Connecting to server %s on port %d..." % [LobbyState.server_address, LobbyState.PORT])
	var error = peer.create_client(LobbyState.server_address, LobbyState.PORT)
	print(error)
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
