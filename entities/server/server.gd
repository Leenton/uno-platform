extends Node

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(ServerState.port, ServerState.MAX_CONNECTIONS)

	if error:
		return error

	multiplayer.multiplayer_peer = peer
	print("Server is now listenting...")

func _on_peer_connected(id):
	print("Peer connected: %d" % id)

func _on_peer_disconnected(id):
	print("Peer disconnected: %d" % id)
	var player = ServerState.players.get(id, null)
	if player:
		ServerState.players[id].connection_status = Player.ConnectionStatus.DISCONNECTED
		EventBus.push(Event.Type.PLAYER_DISCONNECTED, {'name' = player.name}, ServerState.get_connected_players_ids())
	else:
		# TODO: The  player id could not be found in our list of players, this is problem
		pass

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
		Event.Type.KICK_PLAYER: _kick_player(e)
		Event.Type.LEAVE_TABLE: _leave_table(e)
		Event.Type.SET_READY_STATUS: _set_ready_status(e)
		Event.Type.PROMOTE_TO_CREATOR: _promote_to_creator(e)
		Event.Type.DELETE_TABLE: _delete_table(e)
		Event.Type.PLAY_CARD: _play_card(e)
		Event.Type.DRAW_CARD: _draw_card(e)
		Event.Type.CALL_OUT_UNO: _call_out_uno(e)
		Event.Type.REORDER_CARDS: _reorder_cards(e)
		Event.Type.FOCUS_ON_CARD: _focus_on_card(e)
		Event.Type.CHAT: _chat(e)
		Event.Type.NULL:
			return

func _player_connected(event : Event):
	# Validate player name
	var player_name := str(event.payload.get('name', '')).strip_edges()
	if player_name.length() == 0:
		EventBus.push(Event.Type.INVALID_PLAYER_NAME, {}, [event.source])
		return

	# Check if the player name is already taken by a connected player
	var existing_player = ServerState.get_player_by_name(player_name)

	if existing_player and existing_player.connection_status == Player.ConnectionStatus.CONNECTED:
		EventBus.push(Event.Type.PLAYER_NAME_TAKEN, {}, [event.source])
		return

	# Check if the player name belongs to a disconnected player
	if existing_player and existing_player.connection_status == Player.ConnectionStatus.DISCONNECTED:
		EventBus.push(Event.Type.PLAYER_CONNECTED, {'name' = player_name}, ServerState.get_connected_players_ids())
		existing_player.id = event.source
		existing_player.connection_status = Player.ConnectionStatus.CONNECTED

		# If the player was in a game, re-add them to it
		if ServerState.get_player_joined_table(existing_player.name) != '':
			# TODO: Logic to rejoin the table and change game state and etc accordingly

			return

	else:
		# Add the new player
		EventBus.push(Event.Type.PLAYER_CONNECTED, {'name' = player_name}, ServerState.get_connected_players_ids())
		ServerState.players[event.source] = Player.make(player_name, event.source)
		
	EventBus.push(
		Event.Type.PLAYER_ENTER_LOBBY,
		{
			'tables': ServerState.get_tables_for_lobby_screen(),
			'players': ServerState.get_connected_players().map(func(p): return p.name)},
		[event.source]
	)

func _update_table_list_for_clients():
	EventBus.push(
		Event.Type.UPDATE_CLIENT_TABLE_LIST,
		{'tables': ServerState.get_tables_for_lobby_screen()},
		ServerState.get_connected_players().map(func(p): return p.id)
	)

func _create_table(event : Event):
	var table_name := str(event.payload.get('table_name', '')).strip_edges()
	if ServerState.tables.get(table_name, null):
		EventBus.push(
			Event.Type.TABLE_ALREADY_EXISTS,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			[event.source]
		)

		return
	
	var creator: String = ServerState.players[event.source].name

	ServerState.tables[table_name] = Table.make(table_name, [creator],[], creator)

	_update_table_list_for_clients()

	EventBus.push(
		Event.Type.CLIENT_ENTER_TABLE,
		{'table': ServerState.tables[table_name].get_data()},
		[event.source]
	)

func _join_table(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	if table == null:
		EventBus.push(
			Event.Type.PLAYER_JOINED_NON_EXISTENT_TABLE,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			[event.source]
		)

	table.players.append(ServerState.players[event.source].name)

	EventBus.push(
		Event.Type.CLIENT_ENTER_TABLE,
		{'table': table.get_data()},
		[event.source]
	)

func _set_rules(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	
	if table and table.state == Table.State.WAITING and table.creator == ServerState.players[event.source].name:
		table.draw_to_play = event.payload['draw_to_play']
		table.play_at_draw = event.payload['play_at_draw']
		table.jump_in_allowed = event.payload['jump_in_allowed']
		table.stack_cards = event.payload['stack_cards']
		table.swap_on_seven = event.payload['swap_on_seven']
		table.swap_on_zero = event.payload['swap_on_zero']
		table.max_players = event.payload['max_players']
		table.time_per_turn = event.payload['time_per_turn']
		table.spectators_can_see_cards = event.payload['spectators_can_see_cards']

		_update_table_list_for_clients()

func _start_game(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	
	if (table
		and table.state == Table.State.WAITING
		and table.creator == ServerState.players[event.source].name
		and table.playsers.size() >= 2
		and table.max_players >= table.players.size()
		and ( # Check the ready status of all players
			# TODO: figure out how to store ready status and implement a way to check it here
			true
		 )
	):
		table.state = Table.State.IN_PROGRESS
		# TODO: Initialize game data

func _abort_game(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	if (table
		and table.state == Table.State.IN_PROGRESS
		and table.creator == ServerState.players[event.source].name
	):
		# Reset table state and game data
		table.game_data = {} # TODO: re structure game data properly when we know what the data looks like
		table.state = Table.State.WAITING
		_update_table_list_for_clients()

		# Notify all players in the table that the game has been aborted
		EventBus.push(
			Event.Type.PLAYER_ENTER_LOBBY,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			[table.players.map(
				func(n): return ServerState.get_player_id_by_name(n)
			)]
		)

func _kick_player(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	var player_to_kick := ServerState.get_player_by_name(event.payload.get('player_name'))
	var can_kick := (
		table
		and table.creator == ServerState.players[event.source].name
		and player_to_kick
		and player_to_kick.name != table.creator
		and table.players.has(player_to_kick.name) # TODO refactor when we re structure players as Dictionary
	)

	if can_kick and (table.state == Table.State.WAITING or table.state == Table.State.COMPLETED):
		table.players.erase(player_to_kick.name)
		_update_table_list_for_clients()

		EventBus.push(
			Event.Type.PLAYER_ENTER_LOBBY,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			[player_to_kick.id]
		)

	if can_kick and table.state == Table.State.IN_PROGRESS:
		# TODO: Implement kick player logic when the game is in progress
		pass

func _leave_table(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	
	if table and (table.state == Table.State.WAITING or table.state == Table.State.COMPLETED):
		table.players.erase(ServerState.players[event.source].name)
		_update_table_list_for_clients()

		EventBus.push(
			Event.Type.PLAYER_ENTER_LOBBY,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			[event.source]
		)

	if table and table.state == Table.State.IN_PROGRESS:
		# TODO: Handle player leaving during an active game
		pass

func _set_ready_status(event : Event):
	var player : Player = ServerState.players.get(event.source, -1)
	if not player:
		return

	var player_ready = event.payload.get('ready', null)
	if player_ready is bool:
		# TODO: Implement set ready status logic
		pass

func _promote_to_creator(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	var new_creator := ServerState.get_player_by_name(event.payload.get('new_creator'))
	
	if new_creator and table and table.creator.to_lower() == ServerState.players[event.source].name.to_lower():
		table.creator = new_creator.name
		_update_table_list_for_clients()

func _delete_table(event : Event):
	var table := ServerState.get_table_by_name(event.payload.get('table_name'))
	
	if table and table.creator == ServerState.players[event.source].name:
		ServerState.tables.erase(table.name)

		_update_table_list_for_clients()

		EventBus.push(
			Event.Type.PLAYER_ENTER_LOBBY,
			{'tables': ServerState.get_tables_for_lobby_screen()},
			table.players.map(
				func(n): return ServerState.get_player_by_name(n) if ServerState.get_player_by_name(n) else null
			)
		)

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
