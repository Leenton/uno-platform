extends Node

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(ServerState.PORT, ServerState.MAX_CONNECTIONS)

	if error:
		return error

	multiplayer.multiplayer_peer = peer
	print("Server running")

func _on_peer_connected(id):
	print("Peer connected: %d" % id)

func _on_peer_disconnected(id):
	print("Peer disconnected: %d" % id)
	ServerState.players[id].connection_status = Player.ConnectionStatus.DISCONNECTED
	_update_player_list_for_clients()

func _process(_delta: float) -> void:
	var e = EventBus.read()
	if not e:
		return

	match(e.type):
		Event.Type.PLAYER_CONNECTED: _player_connected(e)
		Event.Type.CREATE_TABLE: _create_table(e)
		Event.Type.JOIN_TABLE: _join_table(e)
		Event.Type.SET_RULES: _set_rules(e)
		Event.Type.START_GAME: _start_game(e)
		Event.Type.ABORT_GAME: _abort_game(e)
		Event.Type.DELETE_TABLE: _delete_table(e)
		Event.Type.PLAY_CARD: _play_card(e)
		Event.Type.DRAW_CARD: _draw_card(e)
		Event.Type.CALL_OUT_UNO: _call_out_uno(e)
		Event.Type.REORDER_CARDS: _reorder_cards(e)
		Event.Type.FOCUS_ON_CARD: _focus_on_card(e)
		Event.Type.CHAT: _chat(e)
		null:
			pass

func _player_connected(event : Event):
	# Validate player name
	if event.payload['name'].strip_edges().length() == 0:
		EventBus.push(Event.Type.INVALID_PLAYER_NAME, {}, [event.source])
		return

	# Check if the player name is already taken by a connected player
	var existing_player = ServerState.get_player_by_name(event.payload['name'])

	if existing_player and existing_player.connection_status == Player.ConnectionStatus.CONNECTED:
		EventBus.push(Event.Type.PLAYER_NAME_TAKEN, {}, [event.source])
		return

	# Check if the player name belongs to a disconnected player
	if existing_player and existing_player.connection_status == Player.ConnectionStatus.DISCONNECTED:
		existing_player.id = event.source
		_update_player_list_for_clients()

		# If the player was in a game, re-add them to it
		if ServerState.get_player_joined_table(existing_player.name) != '':
			# TODO: Logic to rejoin the table and change game state and etc accordingly

			return

	else:
		# Add the new player
		ServerState.players[event.source] = Player.make(event.payload['name'], event.source)
		_update_player_list_for_clients()

	EventBus.push(Event.Type.PLAYER_ENTER_LOBBY, {'tables': ServerState.get_tables_for_lobby_screen()}, [event.source])

func _update_player_list_for_clients():
	EventBus.push(
		Event.Type.UPDATE_CLIENT_PLAYER_LIST,
		{'players': ServerState.get_connected_players().map(func(p): return p.name)},
		ServerState.get_connected_players().map(func(p): return p.id)
	)

func _update_table_list_for_clients():
	EventBus.push(
		Event.Type.UPDATE_CLIENT_TABLE_LIST,
		{'tables': ServerState.get_tables_for_lobby_screen()},
		ServerState.get_connected_players().map(func(p): return p.id)
	)

func _create_table(event : Event):
	var table_name: String = event.payload['table_name'].strip_edges()
	if not ServerState.tables.get(table_name, null):
		EventBus.push(
			Event.Type.TABLE_ALREADY_EXISTS,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			[event.source]
		)

		return
	
	var creator: String = ServerState.players[event.source].name

	ServerState.tables[table_name] = Table.make(table_name, [creator],[], {}, creator)

	_update_table_list_for_clients()

	EventBus.push(
		Event.Type.CLIENT_ENTER_TABLE,
		{'table': ServerState.tables[event.payload['table_name']].get_data()},
		[event.source]
	)

func _join_table(event : Event):
	var table_name: String = event.payload['table_name']
	var player_name: String = ServerState.players[event.source].name

	var table: Table = ServerState.tables.get(table_name, null)
	if table == null:
		EventBus.push(
			Event.Type.PLAYER_JOINED_NON_EXISTENT_TABLE,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			[event.source]
		)

	table.players.append(player_name)

	EventBus.push(
		Event.Type.CLIENT_ENTER_TABLE,
		{'table': table.get_data()},
		[event.source]
	)

func _set_rules(event : Event):
	var table_name: String = event.payload['table_name']
	var rules: Dictionary = event.payload['rules']

	var table: Table = ServerState.tables.get(table_name, null)
	if table and table.state == Table.State.WAITING and table.creator == ServerState.players[event.source].name:
		table.rules = rules
		_update_table_list_for_clients()

func _start_game(event : Event):
	var table_name: String = event.payload['table_name']
	var table: Table = ServerState.tables.get(table_name, null)
	if table and table.state == Table.State.WAITING and table.creator == ServerState.players[event.source].name:
		table.state = Table.State.IN_PROGRESS
		# TODO: Initialize game data

func _abort_game(event : Event):
	# TODO: Implement abort game logic
	pass

func _kick_player(event : Event):
	# TODO: Implement kick player logic
	pass

func _delete_table(event : Event):
	var table_name: String = event.payload['table_name']
	var table: Table = ServerState.tables.get(table_name, null)
	if table and table.creator == ServerState.players[event.source].name:
		ServerState.tables.erase(table_name)

		_update_table_list_for_clients()

		EventBus.push(
			Event.Type.PLAYER_ENTER_LOBBY,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			table.players.map(func(n): return ServerState.get_player_by_name(n) if ServerState.get_player_by_name(n) else null)
		)
	pass

func _play_card(event : Event):
	pass

func _draw_card(event : Event):
	pass

func _call_out_uno(event : Event):
	pass

func _reorder_cards(event : Event):
	pass

func _focus_on_card(event : Event):
	pass

func _chat(event : Event):
	pass
