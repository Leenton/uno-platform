extends Node

const PORT = 8080
var server_address = '127.0.0.1'

var players: Dictionary[int, Player] = {}
var tables: Dictionary[String, Table] = {}

func get_player_id_by_name(player_name: String) -> int:
	for player_id in players.keys():
		if players[player_id]['name'].to_lower() == player_name.to_lower():
			return player_id
	
	return -1

func get_player_by_name(player_name: String) -> Player:
	for player_id in players.keys():
		if players[player_id]['name'].to_lower() == player_name.to_lower():
			return players[player_id]
	
	return null

func get_player_joined_table(player_name: String) -> String:
	for table in tables.keys():
		for joined_players in tables[table].players:
			if joined_players.to_lower() == player_name.to_lower():
				return table

	return ""

func get_connected_players() -> Array[Player]:
	var connected_players: Array[Player] = []
	for player_id in players.keys():
		if players[player_id].connection_status == Player.ConnectionStatus.CONNECTED:
			connected_players.append(players[player_id])
	return connected_players

func get_disconnected_players() -> Array:
	var disconnected_players: Array = []
	for player_id in players.keys():
		if players[player_id].connection_status == Player.ConnectionStatus.DISCONNECTED:
			disconnected_players.append(players[player_id])
	return disconnected_players

func get_tables_for_lobby_screen() -> Array[Dictionary]:
	var table_list: Array[Dictionary] = []
	for table in tables.keys():
		table_list.append({
			"name": tables[table].name,
			"players": tables[table].players,
			"creator": tables[table].creator,
			"state" : tables[table].state,
			"rules" : tables[table].rules
		})
	return table_list
